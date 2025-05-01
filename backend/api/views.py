import os
import tempfile
from django.http import JsonResponse
from rest_framework.generics import ListAPIView
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import api_view, parser_classes, permission_classes
from rest_framework.permissions import IsAuthenticated

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_recruiter_images(request):
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can access this endpoint"}, status=403)
        recruiter = Recruiter.objects.get(user=request.user)
        logo_url = request.build_absolute_uri(recruiter.logo.url) if recruiter.logo else ""
        cover_url = request.build_absolute_uri(recruiter.cover.url) if recruiter.cover else ""
        return Response({
            "logo_url": logo_url,
            "cover_url": cover_url
        }, status=200)
    except Recruiter.DoesNotExist:
        return Response({"error": "Recruiter profile not found"}, status=404)
    except Exception as e:
        return Response({"error": str(e)}, status=500)
from rest_framework.parsers import MultiPartParser, FormParser
from django.contrib.auth import authenticate, login, logout
from rest_framework.views import APIView
from .models import User, Recruiter, JobSeeker, Job, Application
from .serializers import (UserSerializer, JobSerializer, JobApplicationSerializer,
                          JobSeekerSerializer, JobSuggestionSerializer)

from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404
from utils.cv_processor import  gemini_parse_overview, fetch_and_compare_overviews, process_cv
from django_filters.rest_framework import DjangoFilterBackend
from django.contrib.auth.hashers import check_password
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.serializers import AuthTokenSerializer
from django.utils import timezone
from rest_framework.permissions import AllowAny

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Recruiter, Job, Application

@api_view(['POST'])
@permission_classes([AllowAny])
def search_jobs(request):
    query = request.data.get('query', '').strip()
    if not query:
        return Response({"error": "Search query is required."}, status=400)
    jobs = Job.objects.filter(
        title__icontains=query
    ) | Job.objects.filter(
        description__icontains=query
    )
    from .serializers import JobSerializer
    serializer = JobSerializer(jobs.distinct(), many=True, context={'request': request})
    return Response({"results": serializer.data}, status=200)

def home(request):
    return JsonResponse({"message": "Welcome to the Job Portal API!"})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_total_gemini_suggestions(request):
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can access this endpoint."}, status=403)
        recruiter = Recruiter.objects.get(user=request.user)
        jobs = Job.objects.filter(recruiter=recruiter)
        total_suggestions = Application.objects.filter(job__in=jobs, is_suggestion=True).count()
        return Response({"total_gemini_suggestions": total_suggestions}, status=200)
    except Recruiter.DoesNotExist:
        return Response({"error": "Recruiter profile not found."}, status=404)
    except Exception as e:
        return Response({"error": str(e)}, status=500)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_jobseeker_by_email(request):
    email = request.query_params.get('email')
    if not email:
        return Response({"error": "Email query parameter is required."}, status=status.HTTP_400_BAD_REQUEST)
    try:
        jobseeker = JobSeeker.objects.get(user__email=email)
        serializer = JobSeekerSerializer(jobseeker, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker not found."}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_suggested_jobs_for_jobseeker(request):
    try:
        job_seeker = JobSeeker.objects.get(user=request.user)
        applications = Application.objects.filter(jobseeker=job_seeker, is_suggestion=True)
        serializer = JobApplicationSerializer(applications, many=True)
        return Response({
            "resp": 1,
            "suggested_jobs": serializer.data
        }, status=status.HTTP_200_OK)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def reject_suggested_job(request):
    try:
        job_seeker = JobSeeker.objects.get(user=request.user)
        job_id = request.data.get('job_id')
        if not job_id:
            return Response({"error": "job_id is required"}, status=status.HTTP_400_BAD_REQUEST)
        application = Application.objects.filter(jobseeker=job_seeker, job__id=job_id, is_suggestion=True).first()
        if not application:
            return Response({"error": "Suggested job not found"}, status=status.HTTP_404_NOT_FOUND)
        application.delete()
        return Response({"message": "Suggested job rejected successfully"}, status=status.HTTP_200_OK)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_accepted_jobs_for_jobseeker(request):
    try:
        job_seeker = JobSeeker.objects.get(user=request.user)
        applications = Application.objects.filter(jobseeker=job_seeker, state='accepted')
        serializer = JobApplicationSerializer(applications, many=True)
        return Response({
            "resp": 1,
            "accepted_jobs": serializer.data
        }, status=status.HTTP_200_OK)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([AllowAny])
def public_hot_jobs(request):
    import datetime
    from django.db.models import Q
    from .serializers import JobSerializer
    try:
        today = datetime.date.today()
        jobs = Job.objects.filter(
            Q(expiry_date__isnull=True) | Q(expiry_date__gte=today)
        ).order_by('-id')[:10]
        serializer = JobSerializer(jobs, many=True, context={'request': request})
        return Response({
            "resp": 1,
            "hot_jobs": serializer.data
        }, status=status.HTTP_200_OK)
    except Exception as e:
        import traceback
        import logging
        logger = logging.getLogger(__name__)
        logger.error(f"Exception in create_job: {str(e)}")
        logger.error(traceback.format_exc())
        return Response({
            "resp": 0,
            "message": str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# تسجيل مستخدم جديد (Recruiter أو Job Seeker)
@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    try:
        data = request.data.copy()
        
        # إزالة الحقول غير المطلوبة بناءً على نوع المستخدم
        if data.get('user_type') == 'job_seeker':
            data.pop('company_name', None)
            data.pop('company_description', None)
        elif data.get('user_type') == 'recruiter':
            data.pop('work_mode', None)
            data.pop('preferred_job_type', None)
            data.pop('preferred_location', None)
            data.pop('salary_expectation', None)

        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            user = serializer.save()
            
            # تعيين full_name إذا كان موجودًا
            if data.get('full_name'):
                user.full_name = data.get('full_name')
            user.save()

            # إنشاء JobSeeker مع التفضيلات إذا كان المستخدم Job Seeker
            if user.user_type == 'job_seeker':
                JobSeeker.objects.create(
                    user=user,
                    full_name=data.get('full_name'),
                    work_mode=data.get('work_mode'),
                    preferred_job_type=data.get('preferred_job_type'),
                    preferred_location=data.get('preferred_location'),
                    salary_expectation=data.get('salary_expectation')
                )

            token, created = Token.objects.get_or_create(user=user)
            return Response({
                "message": "User created successfully",
                "token": token.key,
                "user_type": user.user_type
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# تسجيل الدخول (Recruiter أو Job Seeker)
from rest_framework_simplejwt.tokens import RefreshToken
import threading

def generate_suggestions_for_recruiter(recruiter):
    from .models import Application, JobSeeker, Job
    try:
        jobs = Job.objects.filter(recruiter=recruiter)
        for job in jobs:
            job_details = f"""
            Title: {job.title}
            Description: {job.description}
            Category: {job.category}
            Type: {job.type}
            Level: {job.level}
            Experience: {job.experience}
            Qualification: {job.qualification}
            Salary: {job.salary}
            """
            matching_cvs = fetch_and_compare_overviews(job.title, job_details)
            for match in matching_cvs:
                job_seeker = JobSeeker.objects.get(user__id=match["job_seeker_id"])
                existing_application = Application.objects.filter(job=job, jobseeker=job_seeker).first()
                if existing_application:
                    continue
                Application.objects.create(
                    job=job,
                    jobseeker=job_seeker,
                    state='suggested',
                    is_suggestion=True,
                    match_score=match["similarity"]
                )
    except Exception as e:
        import logging
        logger = logging.getLogger(__name__)
        logger.error(f"Error generating suggestions for recruiter {recruiter.id}: {str(e)}")

@api_view(['POST'])
@permission_classes([AllowAny])
def login_user(request):
    email = request.data.get("email")
    password = request.data.get("password")
    requested_user_type = request.data.get("user_type")  # New: user_type from request
    
    if not email or not password or not requested_user_type:
        return Response({"error": "Email, password, and user_type are required"}, 
                        status=status.HTTP_400_BAD_REQUEST)

    # Map frontend user_type to backend user_type
    user_type_map = {
        "jobseeker": "job_seeker",
        "employer": "recruiter"
    }
    mapped_user_type = user_type_map.get(requested_user_type.lower())
    if not mapped_user_type:
        return Response({"error": "Invalid user_type provided"}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Authenticate by checking password manually since login is by email
    if not user.check_password(password):
        return Response({"error": "Invalid credentials"}, 
                        status=status.HTTP_401_UNAUTHORIZED)
    
    # Check if user_type matches
    if user.user_type != mapped_user_type:
        return Response({"error": f"User type mismatch. This account is registered as {user.user_type}."},
                        status=status.HTTP_403_FORBIDDEN)
    
    login(request, user)
    refresh = RefreshToken.for_user(user)

    # If user is recruiter, generate suggestions asynchronously
    company_logo = ""
    company_cover = ""
    profile_image_url = ""
    if user.user_type == 'recruiter':
        try:
            recruiter = Recruiter.objects.get(user=user)
            threading.Thread(target=generate_suggestions_for_recruiter, args=(recruiter,)).start()
            if recruiter.logo:
                company_logo = request.build_absolute_uri(recruiter.logo.url)
            if recruiter.cover:
                company_cover = request.build_absolute_uri(recruiter.cover.url)
        except Recruiter.DoesNotExist:
            pass
    elif user.user_type == 'job_seeker':
        try:
            job_seeker = JobSeeker.objects.get(user=user)
            if job_seeker.profile_image:
                url = job_seeker.profile_image.url
                if url.startswith("http"):
                    profile_image_url = url
                else:
                    profile_image_url = request.build_absolute_uri(url)
        except JobSeeker.DoesNotExist:
            pass
    
    response_data = {
        "message": "Login successful",
        "refresh": str(refresh),
        "access": str(refresh.access_token),
        "user_id": user.id,
        "user_type": user.user_type,
        "email": user.email,
        "company_logo": company_logo,
        "company_cover": company_cover,
        "profile_image_url": profile_image_url
    }
    
    return Response(response_data, status=status.HTTP_200_OK)

# تسجيل الخروج
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_user(request):
    import logging
    logger = logging.getLogger(__name__)
    logger.info(f"Logout request by user: {request.user}")
    return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    try:
        user = request.user
        old_password = request.data.get("old_password")
        password = request.data.get("password")  # تغيير من new_password إلى password
        password_confirmation = request.data.get("password_confirmation")
        entity = request.data.get("entity")  # للتوافق مع الفرونت إند، لكن لن نستخدمه حاليًا

        # التحقق من وجود الحقول
        errors = {}
        if not old_password:
            errors["old_password"] = "Old password is required"
        if not password:
            errors["password"] = "New password is required"
        if not password_confirmation:
            errors["password_confirmation"] = "Password confirmation is required"

        if errors:
            return Response({"errors": errors}, status=status.HTTP_400_BAD_REQUEST)

        # التحقق من تطابق كلمة المرور الجديدة وتأكيدها
        if password != password_confirmation:
            return Response(
                {"error": "New password and confirmation do not match"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # التحقق من قوة كلمة المرور (اختياري)
        if len(password) < 8:
            return Response(
                {"error": "New password must be at least 8 characters long"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # التحقق من كلمة المرور القديمة
        if not user.check_password(old_password):
            return Response(
                {"error": "Old password is incorrect"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # تعيين كلمة المرور الجديدة
        user.set_password(password)
        user.save()

        return Response(
            {"resp": 1, "message": "Password changed successfully"},
            status=status.HTTP_200_OK
        )
    except Exception as e:
        return Response(
            {"error": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
# تحديث ملف الـ Recruiter
from rest_framework.parsers import MultiPartParser, FormParser
from .serializers import UserSerializer, RecruiterSerializer

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def update_recruiter_profile(request):
    import logging
    logger = logging.getLogger(__name__)
    try:
        if request.user.user_type != 'recruiter':
            return Response(
                {"error": "Only recruiters can update their profile"},
                status=status.HTTP_403_FORBIDDEN
            )

        recruiter = Recruiter.objects.get(user=request.user)
        user = request.user

        if request.method == 'GET':
            user_data = {
                'email': user.email,
                'full_name': user.full_name,
                'country': user.country,
                'phone': user.phone,
            }
            recruiter_data = RecruiterSerializer(recruiter, context={'request': request}).data
            # تعديل الحقول لتتوافق مع الفرونت إند
            profile_data = {
                'email': user_data['email'],
                'full_name': user_data['full_name'],
                'address': user_data['country'],  # الفرونت إند يتوقع address بدلاً من country
                'name': recruiter_data['company_name'],  # الفرونت إند يتوقع name بدلاً من company_name
                'description': recruiter_data['company_description'],  # الفرونت إند يتوقع description
                'logo': recruiter_data['logo'] if recruiter_data['logo'] else "",
                'cover': recruiter_data['cover'] if recruiter_data['cover'] else "",
            }
            logger.info(f"GET recruiter profile data: {profile_data}")
            return Response(profile_data, status=status.HTTP_200_OK)

        elif request.method == 'PUT':
            logger.info(f"PUT recruiter profile update request data: {request.data}")
            logger.info(f"PUT recruiter profile update request files: {request.FILES}")
            # Map frontend fields to backend fields
            user_data = {
                'email': request.data.get('email', user.email),
                'full_name': request.data.get('full_name', user.full_name),
                'country': request.data.get('address', user.country),
                'phone': request.data.get('phone', user.phone),
            }
            user_serializer = UserSerializer(user, data=user_data, partial=True)
            if not user_serializer.is_valid():
                logger.error(f"User serializer errors: {user_serializer.errors}")
                return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            user_serializer.save()

            recruiter_data = {
                'company_name': request.data.get('name', recruiter.company_name),
                'company_description': request.data.get('description', recruiter.company_description),
                'logo': request.FILES.get('logo', recruiter.logo),
                'cover': request.FILES.get('cover', recruiter.cover),
            }
            recruiter_serializer = RecruiterSerializer(recruiter, data=recruiter_data, partial=True, context={'request': request})
            if not recruiter_serializer.is_valid():
                logger.error(f"Recruiter serializer errors: {recruiter_serializer.errors}")
                return Response(recruiter_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            recruiter_serializer.save()

            # تعديل الاستجابة لتتوافق مع توقعات الفرونت إند
            profile_data = {
                'email': user_serializer.data['email'],
                'full_name': user_serializer.data['full_name'],
                'address': user_serializer.data['country'],
                'name': recruiter_serializer.data['company_name'],
                'description': recruiter_serializer.data['company_description'],
                'logo': recruiter_serializer.data['logo'] if recruiter_serializer.data['logo'] else "",
                'cover': recruiter_serializer.data['cover'] if recruiter_serializer.data['cover'] else "",
                'entity': user.user_type,  # إضافة entity لتتوافق مع setAuthStatus
            }
            logger.info(f"PUT recruiter profile updated data: {profile_data}")
            return Response(profile_data, status=status.HTTP_200_OK)

    except Recruiter.DoesNotExist:
        logger.error("Recruiter profile not found")
        return Response(
            {"error": "Recruiter profile not found"},
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as e:
        logger.error(f"Exception in update_recruiter_profile: {str(e)}")
        return Response(
            {"error": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
    
# تحديث ملف الـ Job Seeker
from rest_framework.parsers import MultiPartParser, FormParser
@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def update_job_seeker_profile(request):
    try:
        # التحقق من أن المستخدم من نوع job_seeker
        if request.user.user_type != 'job_seeker':
            return Response(
                {"error": "Only job seekers can access this endpoint"},
                status=status.HTTP_403_FORBIDDEN
            )

        # جلب بيانات المستخدم وملف JobSeeker
        user = request.user
        try:
            job_seeker = JobSeeker.objects.get(user=user)
        except JobSeeker.DoesNotExist:
            return Response(
                {"error": "Job Seeker profile not found"},
                status=status.HTTP_404_NOT_FOUND
            )

        # التعامل مع طلب GET (جلب بيانات المستخدم)
        if request.method == 'GET':
            import traceback
            try:
                serializer = JobSeekerSerializer(job_seeker, context={'request': request})
                return Response(
                    {
                        "message": "Profile retrieved successfully",
                        "user": serializer.data
                    },
                    status=status.HTTP_200_OK
                )
            except Exception as e:
                error_message = str(e)
                tb = traceback.format_exc()
                print(f"Error serializing JobSeeker profile: {error_message}")
                print(tb)
                return Response(
                    {"error": "Failed to serialize profile data", "details": error_message},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

        # التعامل مع طلب PUT (تحديث البيانات)
        elif request.method == 'PUT':
            # تحديث بيانات User
            user_data = {
                'username': request.data.get('username', user.username),
                'email': request.data.get('email', user.email),
                'full_name': request.data.get('full_name', user.full_name),
                'country': request.data.get('country', user.country),
                'phone': request.data.get('phone', user.phone),
            }
            user_serializer = UserSerializer(user, data=user_data, partial=True)
            if user_serializer.is_valid():
                user_serializer.save()
            else:
                return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            # تحديث بيانات JobSeeker
            if 'profile_image' in request.FILES:
                print("Profile image received:", request.FILES['profile_image'].name)
            else:
                print("No profile image in request.FILES")

            job_seeker_data = {
                'full_name': request.data.get('full_name', job_seeker.full_name),
                'work_mode': request.data.get('work_mode', job_seeker.work_mode),
                'preferred_job_type': request.data.get('preferred_job_type', job_seeker.preferred_job_type),
                'preferred_location': request.data.get('preferred_location', job_seeker.preferred_location),
                'salary_expectation': request.data.get('salary_expectation', job_seeker.salary_expectation),
                'profile_image': request.FILES.get('profile_image', job_seeker.profile_image),
            }
            for key, value in job_seeker_data.items():
                setattr(job_seeker, key, value)
            job_seeker.save()

            serializer = JobSeekerSerializer(job_seeker, context={'request': request})

            if job_seeker.profile_image:
                print("Profile image URL:", job_seeker.profile_image.url)
            else:
                print("No profile image found for JobSeeker")

            return Response(
                {
                    "message": "Profile updated successfully",
                    "user": serializer.data
                },
                status=status.HTTP_200_OK
            )

    except Exception as e:
        return Response(
            {"error": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

# إنشاء وظيفة جديدة (Recruiter)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_job(request):
    import threading
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can create jobs"}, 
                            status=status.HTTP_403_FORBIDDEN)
            
        recruiter = Recruiter.objects.get(user=request.user)
        job_data = request.data.copy()
        # Remove recruiter from input data since it's read-only in serializer
        if 'recruiter' in job_data:
            job_data.pop('recruiter')
        
        serializer = JobSerializer(data=job_data)
        if serializer.is_valid():
            job = serializer.save(recruiter=recruiter)
            # Start background thread to generate suggestions for this recruiter
            threading.Thread(target=generate_suggestions_for_recruiter, args=(recruiter,)).start()
            return Response({
                "resp": 1,
                "message": "Job posted successfully",
                "job_id": job.id
            }, status=status.HTTP_201_CREATED)
        return Response({
            "resp": 0,
            "message": "Failed to post the job",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({
            "resp": 0,
            "message": str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# عرض الوظائف المنشورة (Recruiter)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def view_posted_jobs(request):
    import logging
    logger = logging.getLogger(__name__)
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can view posted jobs"}, 
                            status=status.HTTP_403_FORBIDDEN)

        recruiter = Recruiter.objects.get(user=request.user)
        jobs = Job.objects.filter(recruiter=recruiter)
        job_data = []

        for job in jobs:
            suggestions_count = Application.objects.filter(job=job, is_suggestion=True).count()
            job_data.append({
                "id": job.id,
                "title": job.title,
                "category": job.category,
                "type": job.type,
                "level": job.level,
                "suggestions_count": suggestions_count,
                "expiry_date": job.expiry_date,
                "description": job.description,
                "qualification": job.qualification,
                "salary": job.salary,
                "experience": job.experience,
                "deadline": job.expiry_date,
            })

        return Response({
            "resp": 1,
            "jobs": job_data
        }, status=status.HTTP_200_OK)
    except Recruiter.DoesNotExist:
        logger.error("Recruiter profile not found for user: %s", request.user)
        return Response({"error": "Recruiter profile not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        logger.error("Exception in view_posted_jobs: %s", str(e))
        return Response({"error": f"Internal server error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# عرض تفاصيل وظيفة مع الاقتراحات (Recruiter)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def view_job_details(request, job_id):
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can view job details"}, 
                            status=status.HTTP_403_FORBIDDEN)

        recruiter = Recruiter.objects.get(user=request.user)
        job = Job.objects.get(id=job_id, recruiter=recruiter)
        serializer = JobSerializer(job)

        # استرجاع الاقتراحات
        suggestions = Application.objects.filter(job=job, is_suggestion=True)
        suggestion_data = []
        for app in suggestions:
            suggestion_data.append({
                "jobseeker_id": app.jobseeker.user_id,
                "full_name": app.jobseeker.full_name,
                "match_score": app.match_score,
                "overview": app.jobseeker.overview,
            })

        return Response({
            "resp": 1,
            "job": serializer.data,
            "suggestions": suggestion_data
        }, status=status.HTTP_200_OK)
    except Job.DoesNotExist:
        return Response({"error": "Job not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Recruiter.DoesNotExist:
        return Response({"error": "Recruiter profile not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# قبول Job Seeker (Recruiter)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def accept_job_seeker(request, application_id):
    try:
        if request.user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can accept job seekers"}, 
                            status=status.HTTP_403_FORBIDDEN)

        application = Application.objects.get(id=application_id, job__recruiter__user=request.user)
        application.state = 'accepted'
        application.save()


        return Response({"message": "Job Seeker accepted successfully"}, 
                        status=status.HTTP_200_OK)
    except Application.DoesNotExist:
        return Response({"error": "Application not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# حذف وظيفة (Recruiter)
class DeleteJobView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, id):
        try:
            if request.user.user_type != 'recruiter':
                return Response({"error": "Only recruiters can delete jobs"},
                                status=status.HTTP_403_FORBIDDEN)

            job = Job.objects.get(id=id, recruiter__user=request.user)
            job.delete()
            return Response({"resp": 1, "message": "Job deleted successfully"},
                            status=status.HTTP_200_OK)
        except Job.DoesNotExist:
            return Response({"resp": 0, "message": "Job not found"},
                            status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"resp": 0, "message": str(e)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# رفع وتحليل السيرة الذاتية (Job Seeker)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def upload_and_analyze_cv(request):
    try:
        user = request.user
        if user.user_type != 'job_seeker':
            return Response({"error": "Only job seekers can upload CVs"}, 
                            status=status.HTTP_403_FORBIDDEN)

        cv_file = request.FILES.get('cv')
        if not cv_file:
            return Response({"error": "CV file is required"}, 
                            status=status.HTTP_400_BAD_REQUEST)

        # حفظ الملف مؤقتًا
        with tempfile.NamedTemporaryFile(delete=False, suffix=cv_file.name) as temp_file:
            for chunk in cv_file.chunks():
                temp_file.write(chunk)
            temp_file_path = temp_file.name

        # إعداد بيانات الملف الشخصي
        job_seeker = JobSeeker.objects.get(user=user)
        profile = {
            "name": user.full_name,
            "email": user.email,
            "contact_info": f"{user.phone}, {user.country}"
        }

        # معالجة السيرة الذاتية
        result = process_cv(temp_file_path, profile)

        # حذف الملف المؤقت
        os.remove(temp_file_path)

        # تخزين النتائج في JobSeeker
        job_seeker.overview = result["overview"]
        job_seeker.classification = result["classification"]
        job_seeker.score = result.get("credibility_score", 0)
        job_seeker.save()

        return Response({
            "message": "CV analyzed successfully",
            "analysis": {
                "ats_score": result["atsScore"],
                "overview": result["overview"],
                "classification": result["classification"],
                "strengths": result.get("strengths", ""),
                "weaknesses": result.get("weaknesses", ""),
                "suggestions_for_improvement": result.get("suggestions_for_improvement", ""),
                "credibility_score": result.get("credibility_score", 0)
            }
        }, status=status.HTTP_200_OK)

    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except ValueError as ve:
        return Response({"error": str(ve)}, 
                        status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": f"Internal server error: {str(e)}"}, 
                        status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# التقديم على وظيفة (Job Seeker)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def apply_for_job(request, job_id):
    try:
        user = request.user
        if user.user_type != 'job_seeker':
            return Response({"error": "Only job seekers can apply for jobs"}, 
                            status=status.HTTP_403_FORBIDDEN)
            
        job = Job.objects.get(id=job_id)
        job_seeker = JobSeeker.objects.get(user=user)

        # التحقق مما إذا كان الـ Job Seeker قد تلقى اقتراحًا لهذه الوظيفة مسبقًا
        existing_application = Application.objects.filter(job=job, jobseeker=job_seeker).first()
        if existing_application and existing_application.is_suggestion:
            return Response({
                "error": "This job has already been suggested to you. You cannot apply manually."
            }, status=status.HTTP_400_BAD_REQUEST)

        # التحقق مما إذا كان الـ Job Seeker قد تقدم لهذه الوظيفة مسبقًا
        if existing_application:
            return Response({
                "error": "You have already applied for this job."
            }, status=status.HTTP_400_BAD_REQUEST)

        # إعداد تفاصيل الوظيفة
        job_details = f"""
        Title: {job.title}
        Description: {job.description}
        Category: {job.category}
        Type: {job.type}
        Level: {job.level}
        Experience: {job.experience}
        Qualification: {job.qualification}
        Salary: {job.salary}
        """

        # إجابات الاستبيان (اختيارية)
        job_seeker_answers = request.data.get("answers", None)

        # مقارنة السيرة الذاتية مع تفاصيل الوظيفة
        matching_cvs = fetch_and_compare_overviews(job.title, job_details, job_seeker_answers)

        # البحث عن السيرة الذاتية الخاصة بهذا الـ Job Seeker
        match = next((cv for cv in matching_cvs if cv["job_seeker_id"] == user.id), None)
        if not match:
            return Response({
                "error": "No matching CV found for this job seeker, or CV analysis not completed."
            }, status=status.HTTP_400_BAD_REQUEST)

        # التحقق من درجة الملاءمة
        match_score = match["similarity"]
        match_threshold = 60

        if match_score < match_threshold:
            return Response({
                "error": f"Your profile does not match this job (Match Score: {match_score:.2f})."
            }, status=status.HTTP_400_BAD_REQUEST)

        # إنشاء طلب جديد
        application = Application.objects.create(
            job=job,
            jobseeker=job_seeker,
            state='pending',
            is_suggestion=False,
            match_score=match_score
        )

        

        return Response({
            "message": "Application submitted successfully",
            "match_score": match_score
        }, status=status.HTTP_201_CREATED)
    except Job.DoesNotExist:
        return Response({"error": "Job not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, 
                        status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# اقتراح Job Seekers (Recruiter)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def suggest_job_seekers(request, job_id):
    try:
        user = request.user
        if user.user_type != 'recruiter':
            return Response({"error": "Only recruiters can suggest job seekers"}, 
                            status=status.HTTP_403_FORBIDDEN)

        job = Job.objects.get(id=job_id)

        # إعداد تفاصيل الوظيفة
        job_details = f"""
        Title: {job.title}
        Description: {job.description}
        Category: {job.category}
        Type: {job.type}
        Level: {job.level}
        Experience: {job.experience}
        Qualification: {job.qualification}
        Salary: {job.salary}
        """

        # مقارنة السير الذاتية
        matching_cvs = fetch_and_compare_overviews(job.title, job_details)

        suggestions = []
        for match in matching_cvs:
            job_seeker = JobSeeker.objects.get(user__id=match["job_seeker_id"])
            
            # التحقق مما إذا كان الـ Job Seeker قد تقدم أو تم اقتراحه مسبقًا
            existing_application = Application.objects.filter(job=job, jobseeker=job_seeker).first()
            if existing_application:
                continue

            # إنشاء اقتراح جديد
            application = Application.objects.create(
                job=job,
                jobseeker=job_seeker,
                state='suggested',
                is_suggestion=True,
                match_score=match["similarity"]
            )

            suggestions.append({
                "job_seeker_id": job_seeker.user_id,
                "username": job_seeker.user.username,
                "name": job_seeker.full_name or getattr(job_seeker.user, 'full_name', ''),
                "match_score": match["similarity"]
            })


        return Response({
            "message": f"Found {len(suggestions)} suitable job seekers",
            "suggestions": suggestions
        }, status=status.HTTP_200_OK)
    except Job.DoesNotExist:
        return Response({"error": "Job not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, 
                        status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_jobseeker_details(request, jobseeker_id):
    jobseeker = get_object_or_404(JobSeeker, user_id=jobseeker_id)
    serializer = JobSeekerSerializer(jobseeker, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_jobseeker_profile_image(request):
    try:
        jobseeker = JobSeeker.objects.get(user=request.user)
        profile_image_url = ""
        if jobseeker.profile_image:
            url = jobseeker.profile_image.url
            if url.startswith("http"):
                profile_image_url = url
            else:
                profile_image_url = request.build_absolute_uri(url)
        return Response({"profile_image_url": profile_image_url}, status=status.HTTP_200_OK)
    except JobSeeker.DoesNotExist:
        return Response({"error": "Job Seeker profile not found"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

from rest_framework.authentication import TokenAuthentication
import logging

logger = logging.getLogger(__name__)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def jobseeker_job_page_details(request, job_id):
    logger.info(f"jobseeker_job_page_details called by user: {request.user}, auth: {request.auth}")
    try:
        if request.user.user_type != 'job_seeker':
            return Response({"error": "Only job seekers can access this endpoint"}, status=status.HTTP_403_FORBIDDEN)
        job = Job.objects.get(id=job_id)
        serializer = JobSerializer(job, context={'request': request})
        return Response({
            "resp": 1,
            "job": serializer.data
        }, status=status.HTTP_200_OK)
    except Job.DoesNotExist:
        return Response({"error": "Job not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        logger.error(f"Exception in jobseeker_job_page_details: {str(e)}")
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def job_and_company_details(request, job_id):
    logger.info(f"job_and_company_details called by user: {request.user}, auth: {request.auth}")
    try:
        if request.user.user_type not in ['job_seeker', 'recruiter']:
            return Response({"error": "Only job seekers and recruiters can access this endpoint"}, status=status.HTTP_403_FORBIDDEN)
        job = Job.objects.get(id=job_id)
        recruiter = job.recruiter
        user = recruiter.user
        job_serializer = JobSerializer(job, context={'request': request})
        company_data = {
            "name": recruiter.company_name,
            "address": user.country,
            "email": user.email,
            "phone": user.phone,
            "logo": request.build_absolute_uri(recruiter.logo.url) if recruiter.logo else "",
            "cover": request.build_absolute_uri(recruiter.cover.url) if recruiter.cover else "",
        }
        return Response({
            "resp": 1,
            "job": job_serializer.data,
            "company": company_data
        }, status=status.HTTP_200_OK)
    except Job.DoesNotExist:
        return Response({"error": "Job not found"}, 
                        status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        logger.error(f"Exception in job_and_company_details: {str(e)}")
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_jobseeker_overview_sections(request, jobseeker_id):
    jobseeker = get_object_or_404(JobSeeker, user_id=jobseeker_id)
    overview_text = jobseeker.overview
    sections = gemini_parse_overview(overview_text)
    return Response(sections, status=status.HTTP_200_OK)

# عرض المتقدمين للوظائف (للـ Employer)
class ViewJobApplicantsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, job_id=None):
        try:
            if request.user.user_type != 'recruiter':
                return Response({"error": "Only recruiters can view job applicants"},
                                status=status.HTTP_403_FORBIDDEN)

            recruiter = Recruiter.objects.get(user=request.user)

            # إذا لم يتم تمرير job_id (عرض جميع المتقدمين لجميع الوظائف)
            if job_id is None:
                jobs = Job.objects.filter(recruiter=recruiter)
                applications = Application.objects.filter(job__in=jobs, is_suggestion=False)
                serializer = JobApplicationSerializer(applications, many=True)
                return Response({
                    "resp": 1,
                    "applicants": serializer.data
                }, status=status.HTTP_200_OK)

            # إذا تم تمرير job_id (عرض المتقدمين بناءً على الـ ML للوظيفة المحددة)
            job = Job.objects.get(id=job_id, recruiter=recruiter)
            applications = Application.objects.filter(job=job, is_suggestion=True)
            serializer = JobApplicationSerializer(applications, many=True)
            return Response({
                "resp": 1,
                "ml_applicants": serializer.data
            }, status=status.HTTP_200_OK)

        except Job.DoesNotExist:
            return Response({"error": "Job not found"},
                            status=status.HTTP_404_NOT_FOUND)
        except Recruiter.DoesNotExist:
            return Response({"error": "Recruiter profile not found"},
                            status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def save_job_preferences(request):
    if request.user.user_type != 'job_seeker':
        return Response({"error": "Only job seekers can set preferences."},
                        status=status.HTTP_403_FORBIDDEN)

    try:
        job_seeker = JobSeeker.objects.get(user=request.user)

        if request.method == 'POST':
            data = request.data

            job_seeker.preferred_job_type = data.get('preferredJobType', '')
            job_seeker.preferred_location = data.get('preferredLocation', '')

            # Clean salary expectation to remove commas and convert to decimal-compatible string
            salary_expectation_raw = data.get('salaryExpectation', '')
            if isinstance(salary_expectation_raw, str):
                salary_cleaned = salary_expectation_raw.replace(',', '').strip()
            else:
                salary_cleaned = str(salary_expectation_raw)
            job_seeker.salary_expectation = salary_cleaned

            job_seeker.work_mode = data.get('workMode', '')
            job_seeker.experience_level = data.get('experienceLevel', '')

            job_seeker.save()

            return Response({"message": "Preferences saved successfully."},
                            status=status.HTTP_200_OK)

        elif request.method == 'GET':
            preferences = {
                "preferredJobType": job_seeker.preferred_job_type,
                "preferredLocation": job_seeker.preferred_location,
                "salaryExpectation": job_seeker.salary_expectation,
                "workMode": job_seeker.work_mode,
                "experienceLevel": job_seeker.experience_level,
            }
            # Check if all preferences are empty or None
            if all(not v for v in preferences.values()):
                return Response(None, status=status.HTTP_200_OK)
            return Response(preferences, status=status.HTTP_200_OK)

    except JobSeeker.DoesNotExist:
        return Response({"error": "Job seeker not found."},
                        status=status.HTTP_404_NOT_FOUND)
