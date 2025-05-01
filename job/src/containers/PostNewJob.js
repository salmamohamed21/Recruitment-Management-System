import React, { useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import axiosInstance from "../utils/axiosInstance";
import Editor from "../widgets/Editor";
import {
  DEFAULT_JOB_LEVELS,
  DEFAULT_JOB_CATEGORIES,
  DEFAULT_JOB_TYPES,
} from "../utils/Consts";
import ErrorMessage from "../components/ErrorMessage";
import { AuthContext } from "../contexts/AuthContext";

const PostNewJob = () => {
  const { auth } = useContext(AuthContext);
  const [formData, setFormData] = useState({
    category: "",
    type: "",
    level: "",
    location: "",
    title: "",
    experience: "",
    qualification: "",
    description: "",
    salary: "",
    expiry_date: "",
  });
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState(null);
  const navigate = useNavigate();

  const handleInputChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const updateDescription = (value) => {
    setFormData({ ...formData, description: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setSuccessMessage(null);

    // Basic form validation
    if (
      !formData.category ||
      !formData.type ||
      !formData.level ||
      !formData.title ||
      !formData.experience ||
      !formData.qualification ||
      !formData.description ||
      !formData.salary ||
      !formData.expiry_date
    ) {
      setError("Please fill all required fields.");
      return;
    }

    try {
      const response = await axiosInstance.post("/api/create-job/", formData);

      if (response.data.resp === 1) {
        setSuccessMessage(
          <span>
            Job posted successfully! Go to{" "}
            <a
              href="/employer/view-posted-jobs"
              style={{ color: "blue", textDecoration: "underline" }}
              onClick={(e) => {
                e.preventDefault();
                navigate("/employer/view-posted-jobs");
              }}
            >
              View Posted Jobs
            </a>{" "}
            to see matching suggestions.
          </span>
        );
        // Call suggest_job_seekers endpoint to generate suggestions
       // try {
         // await axiosInstance.post(`/api/employer/job-suggestions/${response.data.job_id}`);
      //  } catch (error) {
        //  console.error("Error generating job suggestions:", error);
       // }
        // Reset form
        setFormData({
          category: "",
          type: "",
          level: "",
          title: "",
          experience: "",
          qualification: "",
          description: "",
          salary: "",
          expiry_date: "",
        });
      } else {
        setError(response.data.message || "Failed to post the job.");
      }
    } catch (err) {
      console.error("Error during submission:", err);
      setError("Error submitting the form. Please try again.");
    }
  };

  return (
    <div className="job-applied-wrapper table-responsive-sm" id="view-applicants">
      <div className="job-applied-body">
        <form onSubmit={handleSubmit} id="newjob-form">
          {error && <ErrorMessage errorMessage={error} />}
          {successMessage && <p style={{ color: "green" }}>{successMessage}</p>}

          <div className="form-group my-30">
            <select
              className="form-control"
              name="category"
              onChange={handleInputChange}
              value={formData.category}
            >
              <option value="">Select Job Category</option>
              {DEFAULT_JOB_CATEGORIES.map((item, index) => (
                <option value={item.value} key={index}>
                  {item.title}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group my-30">
            <select
              name="type"
              className="form-control"
              onChange={handleInputChange}
              value={formData.type}
            >
              <option value="">Select Job Type</option>
              {DEFAULT_JOB_TYPES.map((item, index) => (
                <option value={item.value} key={index}>
                  {item.title}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group my-30">
            <select
              name="level"
              className="form-control"
              onChange={handleInputChange}
              value={formData.level}
            >
              <option value="">Select Job Level</option>
              {DEFAULT_JOB_LEVELS.map((item, index) => (
                <option value={item.value} key={index}>
                  {item.title}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              name="location"
              placeholder="Job Location e.g New York"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.location}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              name="title"
              placeholder="Job Title e.g Web Developer"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.title}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              name="experience"
              placeholder="Experience e.g 1-2 years"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.experience}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              name="qualification"
              placeholder="Education qualification e.g Bachelors in IT"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.qualification}
            />
          </div>

          <div className="form-group my-30">
            <Editor
              placeholder="Describe job here....."
              handleChange={updateDescription}
              editorHtml={formData.description}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              name="salary"
              placeholder="Salary (e.g. Rs 20000-Rs 40000)"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.salary}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="date"
              name="expiry_date"
              className="form-control p-3"
              onChange={handleInputChange}
              value={formData.expiry_date}
            />
          </div>

          <div className="form-group">
            <button type="submit" className="post-job-btn b-0 px-3 primary">
              Post job
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default PostNewJob;