import React, { useState, useEffect, useRef } from 'react';
import html2pdf from 'html2pdf.js';
import moment from 'moment';
import './ResumePreview.css';
import './Form.css';

const ResumePreview = ({ data }) => {
    const resumeRef = useRef(null);
    const [errors, setErrors] = useState({});

    useEffect(() => {
        const resumeElement = resumeRef.current;
        if (resumeElement) {
            resumeElement.style.overflowY = resumeElement.scrollHeight > resumeElement.clientHeight ? 'scroll' : 'hidden';
        }

       
    }, [data]);
    
    const handleDownload = () => {
        const element = document.getElementById('resume-preview');
        const options = {
            margin: 1,
            filename: 'resume.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
        };
        html2pdf().set(options).from(element).save();
    };

    const formatDate = (date) => {
        return date ? moment(date).format('DD/MM/YYYY') : '';
    };

    return (
        <div className="resume-preview-container">
            <div ref={resumeRef} id="resume-preview" className="resume-preview" style={{ maxHeight: '100vh', overflowY: 'hidden' }}>
                <header>
                    <div className="left-header">
                        <h1 id='cv-name'>{data.name}</h1>
                        <p>{data.jobTitle}</p>
                        <p id='cv-font' style={{ color: errors.dob ? 'red' : 'black' }}>
                            {formatDate(data.dob)}
                            {errors.dob && <span> - {errors.dob}</span>}
                        </p>
                    </div>
                    <div className="right-header">
                        {data.email && <p id='cv-font'><i className="fas fa-envelope"></i> {data.email}</p>}
                        {data.phone && <p id='cv-font'><i className="fas fa-phone"></i> {data.phone}</p>}
                        {data.address && <p id='cv-font' className="address"><i className="fas fa-map-marker-alt"></i> {data.address}</p>}
                    </div>
                </header>
                {data.experience && data.experience.length > 0 && (
                    <section className="experience-section">
                        <h2 id='bolder'>Experience</h2>
                        {data.experience.map((item, index) => (
                            <div key={index} className="experience-item">
                                <h3 id='cv-font'>{item.company}</h3>
                                <h6 id='bolder'>{item.jobTitle}</h6>
                                <p>{formatDate(item.startDate)} - {formatDate(item.endDate)}</p>
                                {errors[`experience_${index}_startDate`] && <span style={{ color: 'red' }}>{errors[`experience_${index}_startDate`]}</span>}
                                {errors[`experience_${index}_endDate`] && <span style={{ color: 'red' }}>{errors[`experience_${index}_endDate`]}</span>}
                            </div>
                        ))}
                    </section>
                )}
                {data.education && data.education.length > 0 && (
                    <section className="education-section">
                        <h2 id='bolder'><i className="fas fa-graduation-cap"></i> Education</h2>
                        {data.education.map((item, index) => (
                            <div key={index} className="education-item">
                                <h3 id='cv-font'>{item.institution}</h3>
                                <p id='cv-font'>{item.degree}</p>
                                <p>Graduation Date: {formatDate(item.graduationDate)}</p>
                                {errors[`education_${index}_graduationDate`] && <span style={{ color: 'red' }}>{errors[`education_${index}_graduationDate`]}</span>}
                            </div>
                        ))}
                    </section>
                )}
                {data.certificates && data.certificates.length > 0 && (
                    <section className="certificates-section">
                        <h2 id='bolder'>Certificates</h2>
                        {data.certificates.map((item, index) => (
                            <div key={index} className="certificate-item">
                                <p id='cv-font'><strong>{item.certificate}</strong></p>
                                <p id='cv-font'>{item.organization}</p>
                                <p>Issued: {formatDate(item.issueDate)}</p>
                                {errors[`certificates_${index}_issueDate`] && <span style={{ color: 'red' }}>{errors[`certificates_${index}_issueDate`]}</span>}
                            </div>
                        ))}
                    </section>
                )}
                {data.skills && data.skills.length > 0 && (
                    <section className="skills-section">
                        <h2 id='bolder'>Skills</h2>
                        <div className="skills-content">
                            {data.skills.map((item, index) => (
                                <div key={index} className="skill-item">
                                    <span id='cv-font'>{item.skill}</span> - <span>{item.level}</span>
                                </div>
                            ))}
                        </div>
                    </section>
                )}
                {data.languages && data.languages.length > 0 && (
                    <section className="languages-section">
                        <h2 id='bolder'>Languages</h2>
                        <div className="languages-content">
                            {data.languages.map((item, index) => (
                                <div key={index} className="language-item">
                                    <span id='cv-font'>{item.language}</span> - <span>{item.level}</span>
                                </div>
                            ))}
                        </div>
                    </section>
                )}
                {data.summary && data.summary.length > 0 && (
                    <section className="summary-section">
                        <h2 id='bolder'>Summary</h2>
                        {data.summary.map((item, index) => (
                            <div key={index} className="summary-item">
                                <p id='cv-font'>{item.summary}</p>
                            </div>
                        ))}
                    </section>
                )}
            </div>
            <button onClick={handleDownload} id="download-pdf">Download as PDF</button>
        </div>
    );
};

export default ResumePreview;