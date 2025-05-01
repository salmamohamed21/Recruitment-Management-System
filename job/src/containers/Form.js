import React, { useState, useEffect } from 'react';
import './Form.css'; 
import '@fortawesome/fontawesome-free/css/all.min.css';

const Form = ({ formData, onFormChange }) => {
  const [currentSection, setCurrentSection] = useState(null);

  // State to hold error messages for personal fields
  const [personalErrors, setPersonalErrors] = useState({
    name: '',
    dob: '',
    phone: '',
    email: ''
  });

  // State to hold errors for experience date validation
  const [experienceErrors, setExperienceErrors] = useState(
    formData.experience ? formData.experience.map(() => ({ date: '' })) : []
  );

  // Update experienceErrors length when the experience array length changes
  useEffect(() => {
    setExperienceErrors(formData.experience.map(() => ({ date: '' })));
  }, [formData.experience.length]);

  // File input handler remains unchanged
  const handleFileChange = (e) => {
    const file = e.target.files && e.target.files[0];
    if (file) {
      const fileType = file.type;
      if (fileType === 'image/png' || fileType === 'image/jpg') {
        onFormChange({ ...formData, profilePicture: URL.createObjectURL(file) });
      } else {
        alert('Please upload a valid image file (PNG or JPG).');
      }
    }
  };

  // Personal field change handler with validation
  const handlePersonalChange = (e) => {
    const { name, value } = e.target;
    let error = '';

    if (name === 'name') {
      if (/\d/.test(value)) {
        error = 'Name should not contain numbers';
      }
    } else if (name === 'email') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(value)) {
        error = 'Invalid email address';
      }
    } else if (name === 'phone') {
      if (!/^01\d{9}$/.test(value)) {
        error = 'Phone number must be exactly 11 digits and start with 01';
      }
    } else if (name === 'dob') {
      const dobDate = new Date(value);
      const minDate = new Date('1970-01-01');
      if (dobDate <= minDate) {
        error = 'Date of birth must be after 1970';
      } else if (dobDate > new Date()) {
        error = 'Date of birth cannot be in the future';
      }
    }
    setPersonalErrors(prev => ({ ...prev, [name]: error }));
    onFormChange({ ...formData, [name]: value });
  };

  // Generic handler for array sections (education, experience, skills, languages, certificates, summary)
  const handleChange = (e, index, section) => {
    const { name, value } = e.target;
    const updatedSection = [...formData[section]];
    updatedSection[index] = {
      ...updatedSection[index],
      [name]: value
    };
    onFormChange({ ...formData, [section]: updatedSection });

    // For experience section, validate that start date is before end date
    if (section === 'experience' && (name === 'startDate' || name === 'endDate')) {
      const expItem = updatedSection[index];
      let dateError = '';
      if (expItem.startDate && expItem.endDate) {
        if (new Date(expItem.startDate) > new Date(expItem.endDate)) {
          dateError = 'Start date must be before end date';
        }
      }
      const newExpErrors = [...experienceErrors];
      newExpErrors[index] = { date: dateError };
      setExperienceErrors(newExpErrors);
    }
  };

  const handleAddItem = (section) => {
    const updatedSection = [...formData[section], {}];
    onFormChange({ ...formData, [section]: updatedSection });
    if (section === 'experience') {
      setExperienceErrors([...experienceErrors, { date: '' }]);
    }
  };

  const handleRemoveItem = (index, section) => {
    const updatedSection = formData[section].filter((_, i) => i !== index);
    onFormChange({ ...formData, [section]: updatedSection });
    if (section === 'experience') {
      const newExpErrors = experienceErrors.filter((_, i) => i !== index);
      setExperienceErrors(newExpErrors);
    }
  };

  const handleSectionClick = (section) => {
    setCurrentSection(section);
  };

  const handleBackClick = () => {
    setCurrentSection(null);
  };

  const renderSectionForm = () => {
    switch (currentSection) {
      case 'personal':
        return (
          <div className="form-section1">
            <h3>Personal Information</h3>
            <label id="Profile-img">
              Profile Picture:
              <input
                id="Profile-img"
                type="file"
                name="profilePicture"
                accept="image/png, image/jpg"
                onChange={handleFileChange}
              />
            </label>
            <label>
              Name:
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handlePersonalChange}
              />
              {personalErrors.name && <span className="error">{personalErrors.name}</span>}
            </label>
            <label>
              Email:
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handlePersonalChange}
              />
              {personalErrors.email && <span className="error">{personalErrors.email}</span>}
            </label>
            <label>
              Phone:
              <input
                type="text"
                name="phone"
                value={formData.phone}
                onChange={handlePersonalChange}
              />
              {personalErrors.phone && <span className="error">{personalErrors.phone}</span>}
            </label>
            <label>
              Address:
              <input
                type="text"
                name="address"
                value={formData.address}
                onChange={(e) => onFormChange({ ...formData, address: e.target.value })}
              />
            </label>
            <label>
              Date of Birth:
              <input
                type="date"
                name="dob"
                value={formData.dob}
                onChange={handlePersonalChange}
              />
              {personalErrors.dob && <span className="error">{personalErrors.dob}</span>}
            </label>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'education':
        return (
          <div className="form-section2">
            <h3>Education</h3>
            {formData.education.map((item, index) => (
              <div key={index}>
                <label>
                  Institution Name:
                  <input
                    type="text"
                    name="institution"
                    value={item.institution || ''}
                    onChange={(e) => handleChange(e, index, 'education')}
                  />
                </label>
                <label>
                  Degree:
                  <input
                    type="text"
                    name="degree"
                    value={item.degree || ''}
                    onChange={(e) => handleChange(e, index, 'education')}
                  />
                </label>
                <label>
                  Graduation Date:
                  <input
                    type="date"
                    name="graduationDate"
                    value={item.graduationDate || ''}
                    onChange={(e) => handleChange(e, index, 'education')}
                  />
                </label>
                <button onClick={() => handleRemoveItem(index, 'education')} id="Remove">
                  Delet <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('education')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'experience':
        return (
          <div className="form-section3">
            <h3>Experience</h3>
            {formData.experience.map((item, index) => (
              <div key={index}>
                <label>
                  Company Name:
                  <input
                    type="text"
                    name="company"
                    value={item.company || ''}
                    onChange={(e) => handleChange(e, index, 'experience')}
                  />
                </label>
                <label>
                  Job Title:
                  <input
                    type="text"
                    name="jobTitle"
                    value={item.jobTitle || ''}
                    onChange={(e) => handleChange(e, index, 'experience')}
                  />
                </label>
                <label>
                  Start Date:
                  <input
                    type="date"
                    name="startDate"
                    value={item.startDate || ''}
                    onChange={(e) => handleChange(e, index, 'experience')}
                  />
                </label>
                <label>
                  End Date:
                  <input
                    type="date"
                    name="endDate"
                    value={item.endDate || ''}
                    onChange={(e) => handleChange(e, index, 'experience')}
                  />
                </label>
                {experienceErrors[index] && experienceErrors[index].date && (
                  <span className="error">{experienceErrors[index].date}</span>
                )}
                <button onClick={() => handleRemoveItem(index, 'experience')} id="Remove">
                  Delet <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('experience')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'skills':
        return (
          <div className="form-section4">
            <h3>Skills</h3>
            {formData.skills.map((item, index) => (
              <div key={index}>
                <label>
                  Skill:
                  <input
                    type="text"
                    name="skill"
                    value={item.skill || ''}
                    onChange={(e) => handleChange(e, index, 'skills')}
                  />
                </label>
                <label>
                  Level:
                  <select
                    name="level"
                    value={item.level || ''}
                    onChange={(e) => handleChange(e, index, 'skills')}
                  >
                    <option value="">Select Level</option>
                    <option value="Beginner">Beginner</option>
                    <option value="Intermediate">Intermediate</option>
                    <option value="Advanced">Advanced</option>
                    <option value="Expert">Expert</option>
                  </select>
                </label>
                <button onClick={() => handleRemoveItem(index, 'skills')} id="Remove">
                  Delet <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('skills')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'languages':
        return (
          <div className="form-section5">
            <h3>Languages</h3>
            {formData.languages.map((item, index) => (
              <div key={index}>
                <label>
                  Language:
                  <input
                    type="text"
                    name="language"
                    value={item.language || ''}
                    onChange={(e) => handleChange(e, index, 'languages')}
                  />
                </label>
                <label>
                  Level:
                  <select
                    name="level"
                    value={item.level || ''}
                    onChange={(e) => handleChange(e, index, 'languages')}
                  >
                    <option value="">Select Level</option>
                    <option value="Beginner">Beginner</option>
                    <option value="Intermediate">Intermediate</option>
                    <option value="Advanced">Advanced</option>
                    <option value="Expert">Expert</option>
                  </select>
                </label>
                <button onClick={() => handleRemoveItem(index, 'languages')} id="Remove">
                  Delet <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('languages')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'certificates':
        return (
          <div className="form-section6">
            <h3>Certificates</h3>
            {formData.certificates.map((item, index) => (
              <div key={index}>
                <label>
                  Certificate Name:
                  <input
                    type="text"
                    name="certificate"
                    value={item.certificate || ''}
                    onChange={(e) => handleChange(e, index, 'certificates')}
                  />
                </label>
                <label>
                  Issuing Organization:
                  <input
                    type="text"
                    name="organization"
                    value={item.organization || ''}
                    onChange={(e) => handleChange(e, index, 'certificates')}
                  />
                </label>
                <label>
                  Issue Date:
                  <input
                    type="date"
                    name="issueDate"
                    value={item.issueDate || ''}
                    onChange={(e) => handleChange(e, index, 'certificates')}
                  />
                </label>
                <button onClick={() => handleRemoveItem(index, 'certificates')} id="Remove">
                  Delet <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('certificates')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      case 'summary':
        return (
          <div className="form-section7">
            <h3>Summary</h3>
            {formData.summary.map((item, index) => (
              <div key={index}>
                <label id="Summary">
                  Summary:
                  <textarea
                    id="Summary"
                    name="summary"
                    value={item.summary || ''}
                    onChange={(e) => handleChange(e, index, 'summary')}
                  />
                </label>
                <button onClick={() => handleRemoveItem(index, 'summary')} id="Remove">
                  <i className="fas fa-trash"></i>
                </button>
              </div>
            ))}
            <button onClick={() => handleAddItem('summary')} id="add">Add</button>
            <button onClick={handleBackClick} id="back">
              <i className="fas fa-arrow-left"></i>
            </button>
          </div>
        );
      default:
        return null;
    }
  };

  return (
    <div className="form-container">
      {currentSection ? (
        renderSectionForm()
      ) : (
        <div className="sections-container">
          <div className="section" onClick={() => handleSectionClick('personal')}>
            Personal Information
          </div>
          <div className="section" onClick={() => handleSectionClick('education')}>
            Education
          </div>
          <div className="section" onClick={() => handleSectionClick('experience')}>
            Experience
          </div>
          <div className="section" onClick={() => handleSectionClick('skills')}>
            Skills
          </div>
          <div className="section" onClick={() => handleSectionClick('languages')}>
            Languages
          </div>
          <div className="section" onClick={() => handleSectionClick('certificates')}>
            Certificates
          </div>
          <div className="section" onClick={() => handleSectionClick('summary')}>
            Summary
          </div>
        </div>
      )}
    </div>
  );
};

export default Form;
