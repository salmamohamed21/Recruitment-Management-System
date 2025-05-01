import React, { useState } from "react";
import Form from "./Form"; 
import ResumePreview from "./ResumePreview";   
import "./CreateCVPage.css"; 
const CreateCVPage = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    address: "",
    dob: "",
    education: [],
    experience: [],
    skills: [],
    languages: [],
    certificates: [],
    summary: [],
  });

  return (
    <div className="create-cv-page">
      <div className="form-container">
        <Form formData={formData} onFormChange={setFormData} />
      </div>
      <div className="resume-preview-container">
        <ResumePreview data={formData} />
      </div>
    </div>
  );
};

export default CreateCVPage;



