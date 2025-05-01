// src/containers/PreferencesQuestionnaire.js
import React, { useState, useEffect, useContext } from "react";
import { useNavigate } from "react-router-dom";
import { AuthContext } from "../contexts/AuthContext";
import useErrorHandler from "../utils/custom-hooks/ErrorHandler";

const PreferencesQuestionnaire = () => {
  const [preferences, setPreferences] = useState({
    preferredJobType: "",
    preferredLocation: "",
    salaryExpectation: "",
    workMode: "",
    experienceLevel: "",
  });
  const [showReminder, setShowReminder] = useState(false);
  const { auth } = useContext(AuthContext);
  const navigate = useNavigate();
  const { error, showError } = useErrorHandler(null);

  useEffect(() => {
    const skipped = localStorage.getItem("skippedPreferences");
    if (skipped) {
      navigate("/jobseeker");
    } else {
      setShowReminder(true);
    }
  }, [navigate]);

  const handleChange = (e) => {
    setPreferences({ ...preferences, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (
      !preferences.preferredJobType ||
      !preferences.preferredLocation ||
      !preferences.salaryExpectation ||
      !preferences.workMode ||
      !preferences.experienceLevel
    ) {
      showError("Please fill all fields");
      return;
    }

    try {
      console.log("Token sent to API:", auth?.token);

      const response = await fetch('http://127.0.0.1:8000/api/preferences/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${auth.token}`
        },
        body: JSON.stringify(preferences)
      });

      if (!response.ok) {
        throw new Error('Failed to save preferences');
      }

      localStorage.setItem("userPreferences", JSON.stringify(preferences));
      localStorage.removeItem("skippedPreferences");
      navigate("/jobseeker");
    } catch (err) {
      showError(err.message);
      // Fallback to local storage if API fails
      localStorage.setItem("userPreferences", JSON.stringify(preferences));
      localStorage.removeItem("skippedPreferences");
      navigate("/jobseeker");
    }
  };

  const handleSkip = () => {
    localStorage.setItem('preferencesSkipped', 'true');
    navigate('/jobseeker');
  };

  return (
    <div className="preferences-questionnaire">
      <h2>Job Preferences</h2>
      {error && <p className="text-danger">{error}</p>}
      {showReminder && (
        <p className="text-warning">
          Please complete your preferences to get better job recommendations!
        </p>
      )}
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Preferred Job Type</label>
          <select name="preferredJobType" onChange={handleChange} className="form-control">
            <option value="">Select Job Type</option>
            <option value="full-time">Full Time</option>
            <option value="part-time">Part Time</option>
            <option value="contract">Contract</option>
          </select>
        </div>
        <div className="form-group">
          <label>Preferred Location</label>
          <input
            type="text"
            name="preferredLocation"
            onChange={handleChange}
            className="form-control"
            placeholder="Enter preferred location"
          />
        </div>
        <div className="form-group">
          <label>Salary Expectation</label>
          <input
            type="text"
            name="salaryExpectation"
            onChange={handleChange}
            className="form-control"
            placeholder="Enter salary expectation"
          />
        </div>
        <div className="form-group">
          <label>Work Mode</label>
          <select name="workMode" onChange={handleChange} className="form-control">
            <option value="">Select Work Mode</option>
            <option value="onsite">Onsite</option>
            <option value="remote">Remote</option>
            <option value="hybrid">Hybrid</option>
          </select>
        </div>
        <div className="form-group">
          <label>Experience Level</label>
          <select name="experienceLevel" onChange={handleChange} className="form-control">
            <option value="">Select Experience Level</option>
            <option value="entry">Entry Level</option>
            <option value="mid">Mid Level</option>
            <option value="senior">Senior Level</option>
          </select>
        </div>
        <div className="form-group">
          <button type="submit" className="btn btn-primary">Submit</button>
        </div>
      </form>
    </div>
  );
};

export default PreferencesQuestionnaire;