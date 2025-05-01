import os
import google.generativeai as genai
from pdf2image import convert_from_path
import pytesseract
from docx import Document
import spacy
import re
from django.conf import settings
import tempfile
import win32com.client  # لتحويل DOCX إلى PDF على Windows
import pythoncom
from api.models import JobSeeker
import difflib
import logging
import time
import json

# Set Tesseract executable path from settings
pytesseract.pytesseract.tesseract_cmd = settings.TESSERACT_PATH

# Load the spaCy model
nlp = spacy.load("en_core_web_sm")

# Configure the Gemini API
genai.configure(api_key=settings.GEMINI_API_KEY)

def is_similar(str1, str2, threshold=0.7):
    """
    Check if two strings are equal ignoring case or have similarity ratio above threshold.
    """
    if not str1 or not str2:
        return False
    str1_lower = str1.lower()
    str2_lower = str2.lower()
    if str1_lower == str2_lower:
        return True
    ratio = difflib.SequenceMatcher(None, str1_lower, str2_lower).ratio()
    return ratio >= threshold

# General function for calling Gemini API
def call_gemini_api(prompt):
    """
    Sends a prompt to the Gemini API and returns the response text.
    """
    try:
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(prompt)
        return response.text.strip()
    except Exception as e:
        print(f"Error calling Gemini API: {str(e)}")
        return None

def convert_docx_to_pdf(file_path):
    """
    Convert a DOCX file to PDF using Microsoft Word (Windows only).
    """
    try:
        pythoncom.CoInitialize()  # تهيئة COM
        word = win32com.client.Dispatch('Word.Application')
        doc = word.Documents.Open(file_path)
        
        # إنشاء مسار مؤقت لملف PDF
        pdf_path = file_path.replace('.docx', '.pdf')
        doc.SaveAs(pdf_path, FileFormat=17)  # FileFormat=17 هو تنسيق PDF
        doc.Close()
        word.Quit()
        pythoncom.CoUninitialize()
        
        return pdf_path
    except Exception as e:
        print(f"Error converting DOCX to PDF: {str(e)}")
        return None

def process_file_with_ocr(file_path):
    """
    Extract text from a file (PDF or DOCX) using OCR and enhance with Gemini.
    """
    try:
        # إذا كان الملف DOCX، قم بتحويله إلى PDF أولاً
        file_extension = file_path.split('.')[-1].lower()
        if file_extension == 'docx':
            pdf_path = convert_docx_to_pdf(file_path)
            if not pdf_path:
                raise ValueError("Failed to convert DOCX to PDF for OCR processing.")
        else:
            pdf_path = file_path

        # استخراج النص باستخدام OCR
        try:
            # Specify the path to Poppler's bin directory from settings
            poppler_path = settings.POPPLER_PATH
            images = convert_from_path(pdf_path, poppler_path=poppler_path)
        except Exception as e:
            if "Unable to get page count" in str(e):
                raise ValueError("Poppler is not installed or not in PATH. Please install Poppler and add it to your system PATH.")
            raise e

        raw_text = ""
        for image in images:
            raw_text += pytesseract.image_to_string(image) + " "

        if not raw_text.strip():
            raise ValueError("No text extracted using OCR.")

        # تحسين النص باستخدام Gemini
        prompt = f"""
        The following text was extracted from a CV using OCR. Clean and enhance it to make it readable and well-structured:
        - Remove irrelevant artifacts (e.g., random symbols like '$1$', '$99\%' should be '99%').
        - Fix duplicates (e.g., if 'java - Expert' and 'java - Beginner' appear, choose the highest level).
        - Reorganize into coherent sections if possible (e.g., personal info, experience, education, skills).
        - Ensure the content remains accurate and professional.

        Extracted Text:
        {raw_text}
        """
        enhanced_text = call_gemini_api(prompt)

        # حذف ملف PDF المؤقت إذا كان DOCX
        if file_extension == 'docx' and pdf_path:
            os.remove(pdf_path)

        return enhanced_text if enhanced_text else raw_text.strip()
    except Exception as e:
        print(f"Error processing file with OCR: {e}")
        raise ValueError(f"Failed to process file with OCR: {str(e)}")

def clean_extracted_text(text):
    """
    Clean and preprocess the extracted text for better presentation.
    """
    try:
        if not text:
            return ""
        text = re.sub(r'\*\*|\*', '', text)
        text = re.sub(r'^\s*-\s*', '', text, flags=re.MULTILINE)
        text = text.strip()
        text = re.sub(r'\n+', '\n\n', text)
        return text
    except Exception as e:
        print(f"Error cleaning text: {str(e)}")
        return text

# Extract job title using spaCy
def extract_job_title(text):
    """
    Extract the job title from the CV text using spaCy.
    """
    try:
        doc = nlp(text)
        job_titles = [ent.text for ent in doc.ents if "developer" in ent.text.lower() or "engineer" in ent.text.lower()]
        return job_titles[0] if job_titles else None
    except Exception as e:
        print(f"Error extracting job title: {e}")
        return None

# Get job title using Gemini
def get_job_title_with_gemini(text):
    """
    Determine the job title using Gemini if spaCy fails to find one.
    """
    prompt = f"""
    Based on the following CV text, determine the most relevant job title:
    {text}
    """
    response_text = call_gemini_api(prompt)
    return response_text or "Unknown"

# Get overview using Gemini
def get_overview(text, job_title):
    """
    Get an overview of the CV using Gemini.
    """
    prompt = f"""
    Based on the following CV, write a structured summary of the candidate's qualifications and background for the job title "{job_title}". 
    Ensure the summary is concise, clear, and formatted as an article with the following sections:

    1. Introduction: Provide a brief overview of the candidate, including their years of experience, primary field, and key strengths.
    2. Education: Summarize the candidate's educational background, degrees, and certifications.
    3. Key Skills: Highlight the candidate's primary technical and professional skills.
    4. Experience Highlights: Summarize relevant work experiences, focusing on significant achievements and responsibilities.
    5. Additional Information: Include any noteworthy soft skills, languages, or other attributes.

    Write the response as a clean, professional article without any bullet points or special formatting characters (like stars or asterisks). Use paragraphs to separate sections, and ensure the language is concise and professional.

    CV Content:
    {text}
    """
    overview = call_gemini_api(prompt)
    if overview is None:
        raise ValueError("Failed to generate CV overview using Gemini API.")
    return overview

# Get strengths using Gemini
def get_strengths(text, job_title):
    """
    Get strengths from the CV using Gemini.
    """
    prompt = f"""
    Based on the following CV, identify and summarize the top strengths of the candidate for the job title "{job_title}".
    Ensure the strengths are presented in a clear and organized format with bullet points. Focus on the following aspects:

    1. Technical Skills: Highlight advanced technical skills directly relevant to the "{job_title}".
    2. Professional Achievements: List any notable accomplishments or recognitions in the candidate's career.
    3. Education and Certifications: Mention key educational qualifications and certifications that add value.
    4. Soft Skills: Include any standout soft skills (e.g., communication, leadership, problem-solving) that are relevant to the job.
    5. Unique Attributes: Any unique qualities that make the candidate a strong fit for the role.

    Format the response in Markdown for readability. Use concise and professional language.
    
    CV Content:
    {text}
    """
    strengths = call_gemini_api(prompt)
    if strengths is None:
        raise ValueError("Failed to generate CV strengths using Gemini API.")
    return strengths

# Get weaknesses using Gemini
def get_weaknesses(text, job_title):
    """
    Get weaknesses from the CV using Gemini.
    """
    prompt = f"""
    Identify the weaknesses of the candidate based on the following CV for the job title "{job_title}":
    {text}
    """
    weaknesses = call_gemini_api(prompt)
    if weaknesses is None:
        raise ValueError("Failed to generate CV weaknesses using Gemini API.")
    return weaknesses

# Get improvements using Gemini
def get_suggestions_for_improvement(text, job_title):
    """
    Provide suggestions for improving the CV to better match the desired job title.
    """
    prompt = f"""
    Provide specific suggestions for improving the CV to better match the requirements of the job title "{job_title}":
    {text}
    """
    suggestions = call_gemini_api(prompt)
    if suggestions is None:
        raise ValueError("Failed to generate CV improvement suggestions using Gemini API.")
    return suggestions

# Get ATS score using Gemini
def get_ats_score(cv_text, job_title):
    """
    Evaluate the resume based on general expectations for the given job title and return only the ATS percentage.
    """
    prompt = f"""
    Hey, act like a skilled and experienced ATS (Applicant Tracking System) with a deep understanding 
    of the tech field, including software engineering, data science, data analysis, and big data engineering. 
    Your task is to evaluate the resume based on general expectations and industry standards for the 
    job title "{job_title}". Assume the following general requirements for the role:

    1. Relevant technical skills (e.g., programming languages, frameworks, tools, or platforms).
    2. Years of experience and relevance to the industry.
    3. Educational qualifications and certifications commonly expected for the role.
    4. Key achievements or responsibilities related to the job title.
    5. Soft skills such as communication, problem-solving, and teamwork abilities.

    You must consider that the job market is highly competitive and assign a percentage matching score 
    based on how well the resume aligns with the general expectations for "{job_title}". 

    Resume:
    {cv_text}

    Provide only the ATS percentage score as follows:
    ATS Score: <percentage>
    """
    response = call_gemini_api(prompt)
    print(f"Raw Gemini API response for ATS score: {response}")  # Debug log
    if response is None:
        print("Gemini API returned None for ATS score")
        raise ValueError("Failed to generate ATS score using Gemini API.")
    try:
        score_line = response.strip().split(":")[-1].strip()
        print(f"Parsed ATS score line: {score_line}")  # Debug log
        if score_line.endswith('%'):
            score_line = score_line[:-1].strip()
        return int(score_line) if score_line.isdigit() else 0
    except Exception as e:
        print(f"Error parsing ATS score: {e}")
        print(f"Response content was: {response}")
        return 0
# Classify CV using Gemini
def classify_cv(text):
    """
    Classify the CV into the most suitable job title using Gemini.
    """
    prompt = f"""
    Based on the following CV:
    {text}

    Analyze the CV content to determine the most suitable job title for the candidate.
    Consider the following aspects while making your decision:
    1. Skills mentioned in the CV.
    2. Professional experience and achievements.
    3. Education and certifications.

    Provide only the most suitable job title as plain text.
    """
    response = call_gemini_api(prompt)
    if response is None:
        raise ValueError("Failed to classify CV using Gemini API.")
    try:
        job_title = response.strip()
        print(f"Classified Job Title: {job_title}")
        return job_title
    except Exception as e:
        print(f"Error classifying CV: {e}")
        return "Unknown"

# Verify CV data integrity using Gemini
def verify_cv_data(cv_text, profile):
    """
    Verify the authenticity and consistency of the CV data using Gemini.
    Returns a verification score (0-100) and a list of inconsistencies.
    """
    prompt = f"""
    You are a highly advanced AI tasked with verifying the authenticity and consistency of a CV against a user's profile.
    Your goal is to check for inconsistencies and potential falsifications in the CV data, and provide a verification score between 0 and 100.

    **Instructions:**
    1. Compare the CV data with the user's profile to ensure consistency in:
       - Name: Ensure the name on the CV matches the profile name.
       - Email: Ensure the email on the CV matches the profile email.
       - Contact Info: Check if the contact info (e.g., phone, country) aligns with the CV.
    2. Check for logical consistency in the CV data:
       - Years of experience: Ensure the years of experience are reasonable given the graduation year (e.g., a 2023 graduate cannot have 10 years of experience).
       - University: Verify if the university mentioned exists and is plausible (e.g., not a made-up name).
       - Skills and experience: Check if the skills and experience are consistent with the candidate's education and timeline.
    3. Identify any signs of exaggeration or falsification (e.g., claiming unrealistic achievements).
    4. Provide a verification score (0-100) based on the consistency and authenticity of the data.
    5. List any inconsistencies or potential issues in a clear format.

    **User Profile:**
    Name: {profile.get('name', '')}
    Email: {profile.get('email', '')}
    Contact Info: {profile.get('contact_info', '')}

    **CV Content:**
    {cv_text}

    **Expected Output:**
    Verification Score: <score>
    Inconsistencies:
    - <Issue 1>
    - <Issue 2>
    """
    response = call_gemini_api(prompt)
    print(f"Raw Gemini API response for verification: {response}")  # Debug log
    if response is None:
        print("Gemini API returned None for verification")
        raise ValueError("Failed to verify CV data using Gemini API.")
    try:
        # Parse the verification score and inconsistencies
        lines = response.split("\n")
        score_line = next(line for line in lines if line.startswith("Verification Score:"))
        score = int(score_line.split(":")[-1].strip())

        inconsistencies = []
        for line in lines:
            if line.startswith("-"):
                inconsistencies.append(line.strip("- ").strip())

        return {
            "credibility_score": score,
            "inconsistencies": inconsistencies
        }
    except Exception as e:
        print(f"Error parsing verification response: {e}")
        print(f"Response content was: {response}")
        return {
            "credibility_score": 0,
            "inconsistencies": ["Unable to verify CV due to an error."]
        }

# Process CV
def process_cv(file_path, profile=None):
    """
    Process a CV file, analyze it using Gemini, and verify its data integrity.
    """
    try:
        # استخراج النص باستخدام OCR
        text = process_file_with_ocr(file_path)
        if not text.strip():
            raise ValueError("Extracted text is empty.")

        print(f"Extracted text: {text[:500]}")  # عرض أول 500 حرف من النص المستخرج

        # استخراج عنوان الوظيفة
        job_title = extract_job_title(text) or get_job_title_with_gemini(text)
        print(f"Job title: {job_title}")

        # الحصول على تحليل النقاط المختلفة
        overview = clean_extracted_text(get_overview(text, job_title))
        strengths = clean_extracted_text(get_strengths(text, job_title))
        weaknesses = clean_extracted_text(get_weaknesses(text, job_title))
        suggestions_for_improvement = clean_extracted_text(get_suggestions_for_improvement(text, job_title))
        ats_score = get_ats_score(text, job_title)
        classification = classify_cv(text)

        # التحقق من صحة البيانات
        verification_result = verify_cv_data(text, profile) if profile else {
            "credibility_score": 0,
            "inconsistencies": ["Profile data not provided for verification."]
        }

        # عرض النتائج
        print(f"Overview: {overview}")
        print(f"Strengths: {strengths}")
        print(f"Weaknesses: {weaknesses}")
        print(f"Suggestions for Improvement: {suggestions_for_improvement}")
        print(f"ATS Score: {ats_score}")
        print(f"Classification: {classification}")
        print(f"Verification: {verification_result}")

        return {
            "jobTitle": job_title,
            "atsScore": ats_score,
            "classification": classification,
            "overview": overview,
            "strengths": strengths,
            "weaknesses": weaknesses,
            "suggestions_for_improvement": suggestions_for_improvement,
            "extractedText": text,
            "credibility_score": verification_result["credibility_score"],
            "inconsistencies": verification_result["inconsistencies"]
        }
    except Exception as e:
        print(f"Error in process_cv: {str(e)}")
        raise ValueError(f"Failed to process CV: {str(e)}")

# Save analysis directly to JobSeeker
def save_analysis(credibility_score , overview, classification, job_seeker_id):
    """
    Save the analysis results directly into the JobSeeker model.
    """
    try:
        job_seeker = JobSeeker.objects.get(user_id=job_seeker_id)
        job_seeker.score = credibility_score
        job_seeker.overview = overview
        job_seeker.classification = classification
        job_seeker.save()
        print(f"Analysis saved for JobSeeker ID {job_seeker_id}")
    except JobSeeker.DoesNotExist:
        print(f"JobSeeker with ID {job_seeker_id} not found.")
    except Exception as e:
        print(f"Error saving analysis: {e}")


def _parse_similarity_score(response: str) -> float:
    """
    Parse the similarity score from the Gemini API response.
    
    Args:
        response (str): The raw response from the Gemini API.
        
    Returns:
        float: The parsed similarity score as a percentage (0 to 100).
               Returns 0 if the score cannot be parsed.
    """
    try:
        # Split the response into lines
        lines = response.strip().split("\n")
        
        # Look for the line containing "Similarity Score"
        score_line = next((line for line in lines if line.startswith("Similarity Score:")), None)
        
        if not score_line:
            print("Error: Similarity Score not found in response.")
            return 0.0
        
        # Extract the score by removing "Similarity Score:" and the "%" sign
        score_str = score_line.replace("Similarity Score:", "").replace("%", "").strip()
        
        # Convert the score to a float
        score = float(score_str)
        
        # Ensure the score is within the valid range (0 to 100)
        if not 0 <= score <= 100:
            print(f"Error: Similarity Score {score} is out of valid range (0-100).")
            return 0.0
            
        return score
        
    except (ValueError, TypeError) as e:
        print(f"Error parsing similarity score: {e}")
        return 0.0


def _prepare_job_seeker_answers(jobseeker):
    """
    Prepare a string representation of the job seeker's answers for comparison.
    """
    try:
        work_mode = getattr(jobseeker, 'work_mode', '')
        preferred_job_type = getattr(jobseeker, 'preferred_job_type', '')
        preferred_location = getattr(jobseeker, 'preferred_location', '')
        salary_expectation = getattr(jobseeker, 'salary_expectation', '')
        experience_level = getattr(jobseeker, 'experience_level', '')

        answers_str = (
            f"Work Mode: {work_mode}\n"
            f"Preferred Job Type: {preferred_job_type}\n"
            f"Preferred Location: {preferred_location}\n"
            f"Salary Expectation: {salary_expectation}\n"
            f"Experience Level: {experience_level}"
        )
        return answers_str
    except Exception as e:
        print(f"Error preparing job seeker answers: {e}")
        return ""

def fetch_and_compare_overviews(job_title: str, job_details: str, job_seeker_answers: str = None) -> list:
    """
    Fetch all JobSeekers and compare their combined overview and answers to job details.
    Only compares entries with the same or similar job_title.
    Returns a list of matching jobseekers sorted by similarity score descending.
    """
    matching_jobseekers = []

    try:
        jobseekers = JobSeeker.objects.all().select_related('user')

        for jobseeker in jobseekers:
            overview = jobseeker.overview
            seeker_job_title = jobseeker.classification

            print(f"Checking JobSeeker ID {jobseeker.user_id} with classification '{seeker_job_title}' and overview present: {bool(overview)}")

            if not is_similar(job_title, seeker_job_title):
                print(f"Skipping JobSeeker ID {jobseeker.user_id} due to job title mismatch.")
                continue

            if not overview:
                print(f"Skipping JobSeeker ID {jobseeker.user_id} due to missing overview.")
                continue

            if job_seeker_answers is None:
                job_seeker_answers_str = _prepare_job_seeker_answers(jobseeker)
            else:
                job_seeker_answers_str = job_seeker_answers

            combined_text = f"{overview}\n\n{job_seeker_answers_str}"
            print(f"Combined text length for JobSeeker ID {jobseeker.user_id}: {len(combined_text)}")

            prompt = f"""
You are an advanced AI model specializing in recruitment and candidate-job matching. Your task is to evaluate the similarity between a job description and a candidate's combined CV overview and job seeker answers, focusing on their alignment in terms of skills, experience, and job-specific requirements.

**Instructions:**
1. Read the "Job Title" and "Job Details" to understand the role and its requirements.
2. Analyze the "Combined CV Overview and Job Seeker Answers" to identify the candidate's skills, experience, and qualifications.
3. Compare the two sections to determine how well the candidate's profile matches the job requirements. Consider the following factors:
   - **Skills Match:** How closely the candidate’s skills (e.g., programming languages, frameworks, tools) align with those required in the job details.
   - **Experience Relevance:** Whether the candidate’s experience (e.g., internships, projects) matches the job’s experience requirements.
   - **Job-Specific Terminology:** The use of relevant industry terms and technologies mentioned in both sections.
   - **Educational Background:** If the candidate’s education aligns with the job’s requirements.
4. Assign a similarity score as a percentage between 0% and 100%, where 0% indicates no alignment and 100% indicates a perfect match. A score below 10% indicates a poor match.
5. Provide a brief explanation (1-2 sentences) justifying the score, focusing on key matches or mismatches.

**Job Title:**
{job_title}

**Job Details:**
{job_details}

**Combined CV Overview and Job Seeker Answers:**
{combined_text}

**Expected Output Format:**
Similarity Score: <score>%
Explanation: <brief explanation of the score>
"""
            response = call_gemini_api(prompt)
            print(f"Raw Gemini API response for JobSeeker ID {jobseeker.user_id}: {response}")
            similarity_score = _parse_similarity_score(response)
            print(f"Similarity score for JobSeeker ID {jobseeker.user_id}: {similarity_score}")

            # Lower threshold to 0 to include all candidates for debugging
            if similarity_score >= 50:
                matching_jobseekers.append({
                    "id": jobseeker.user_id,
                    "name": getattr(jobseeker.user, 'name', '') or getattr(jobseeker.user, 'get_full_name', lambda: '')(),
                    "overview": overview,
                    "classification": jobseeker.classification,
                    "job_seeker_id": jobseeker.user_id,
                    "similarity": similarity_score,
                    "final_score": similarity_score
                })

    except Exception as e:
        print(f"Error fetching and comparing JobSeekers: {e}")

    matching_jobseekers.sort(key=lambda x: x.get("final_score", 0), reverse=True)

    print(f"Matching JobSeekers: {matching_jobseekers}")
    return matching_jobseekers



# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)



def gemini_parse_overview(overview_text, max_retries=3, retry_delay=1):
    """
    Parse the overview text into structured CV sections using Gemini API.
    Dynamically identifies sections based on content and returns a dictionary with section names as keys.

    Args:
        overview_text (str): The CV overview text to parse.
        max_retries (int): Maximum number of retry attempts for API calls.
        retry_delay (int): Delay (in seconds) between retry attempts.

    Returns:
        dict: A dictionary with section names as keys and parsed content as values.
    """
    if not overview_text:
        logger.warning("gemini_parse_overview called with empty overview_text")
        return {}

    logger.info(f"gemini_parse_overview: Input text length: {len(overview_text)} characters")

    prompt = f"""
You are a CV parser. Given the overview text below, extract distinct sections and their content.
Return a JSON object with keys as section names (lowercase, underscores) and values as the section content.
Example output:
{{
  "summary": "Candidate summary here.",
  "education": "Education details here.",
  "work_experience": "Work experience details here."
}}

Overview Text:
{overview_text}
"""

    for attempt in range(1, max_retries + 1):
        try:
            response_text = call_gemini_api(prompt)
            logger.info(f"gemini_parse_overview: Raw response on attempt {attempt}: '{response_text}'")

            # Clean response_text by removing markdown code fences if present
            cleaned_response = response_text.strip()
            if cleaned_response.startswith("```json"):
                cleaned_response = cleaned_response[len("```json"):].strip()
            if cleaned_response.endswith("```"):
                cleaned_response = cleaned_response[:-3].strip()

            # Check for empty or None response
            if not cleaned_response or cleaned_response.strip() == "":
                logger.error(f"gemini_parse_overview: Empty response from Gemini API on attempt {attempt}")
                time.sleep(retry_delay)
                continue

            # Check if response is likely not JSON
            if not cleaned_response.strip().startswith('{'):
                logger.error(f"gemini_parse_overview: Response is not JSON on attempt {attempt}: {cleaned_response}")
                time.sleep(retry_delay)
                continue

            # Parse JSON response
            parsed = json.loads(cleaned_response)

            # Check for API error messages
            if isinstance(parsed, dict) and "error" in parsed:
                logger.error(f"gemini_parse_overview: API error on attempt {attempt}: {parsed['error']}")
                time.sleep(retry_delay)
                continue

            # Ensure the response is a dictionary
            if not isinstance(parsed, dict):
                logger.error(f"gemini_parse_overview: Parsed response is not a dictionary on attempt {attempt}: {parsed}")
                time.sleep(retry_delay)
                continue

            logger.info("gemini_parse_overview: Successfully parsed CV sections")
            return parsed

        except json.JSONDecodeError as e:
            logger.error(f"gemini_parse_overview: JSON decode error on attempt {attempt}: {e}")
            logger.debug(f"gemini_parse_overview: Response text was: {response_text}")
            time.sleep(retry_delay)
        except Exception as e:
            logger.error(f"gemini_parse_overview: Unexpected error on attempt {attempt}: {e}")
            time.sleep(retry_delay)

    logger.error("gemini_parse_overview: Failed to get valid response after retries")
    return {}
