import React, { useState, useEffect, useContext } from "react";
import { AuthContext } from "../contexts/AuthContext";
import axiosInstance from "../utils/axiosInstance";
import { useNavigate } from "react-router-dom";
import { RadialBarChart, RadialBar, Legend } from "recharts";
import "./AtsResult.css";
import axios from "axios";

function AtsResult() {
  const navigate = useNavigate();
  const [file, setFile] = useState(null);
  const [result, setResult] = useState(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const { auth } = useContext(AuthContext);
  const [showResults, setShowResults] = useState(false);
  const [dbPreferences, setDbPreferences] = useState(null);

  // Redirect to login if user is not authenticated
  useEffect(() => {
    console.log("Auth context:", auth); // Debug auth object
    if (!auth?.email || !auth?.token) {
      navigate("/login");
    }
  }, [navigate, auth]);

  // Fetch preferences from backend on mount
  useEffect(() => {
    const fetchPreferences = async () => {
      try {
        const token = auth?.token || localStorage.getItem("accessToken");
        console.log("Token used for preferences request:", token); // Debug token
        if (!token) {
          setError("You are not authenticated. Please log in again.");
          navigate("/login");
          return;
        }
        const response = await axiosInstance.get("/api/preferences/", {
          headers: { Authorization: `Bearer ${token}` },
        });
        setDbPreferences(response.data);
      } catch (err) {
        console.error("Error fetching preferences:", err.response || err.message);
        setError("Failed to fetch preferences. Please try logging in again.");
      }
    };
    fetchPreferences();
  }, [auth, navigate]);

  const handleUpload = async (e) => {
    e.preventDefault();
    setError("");
    setResult(null);

    if (!file) {
      setError("Please upload a file.");
      return;
    }

    // Check if preferences exist in DB before allowing upload
    if (!dbPreferences) {
      setError("Please complete your job preferences before uploading your CV.");
      return;
    }

    const token = auth?.token || localStorage.getItem("accessToken");
    console.log("Token before upload request:", token);
    if (!token) {
      setError("You are not authenticated. Please log in again.");
      navigate("/login");
      return;
    }

    const formData = new FormData();
    formData.append("cv", file);

    setLoading(true);
    setIsLoading(true);
    try {
      const response = await axiosInstance.post("/api/uploads/", formData);
      console.log("Response data:", response.data);
      setResult(response.data.analysis);
      setShowResults(true);
      window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
    } catch (err) {
      console.error("Error uploading CV:", err.response || err.message); // Log detailed error
      setError("Error uploading or analyzing CV: " + (err.response?.statusText || err.message));
    } finally {
      setLoading(false);
      setIsLoading(false);
    }
  };

  const getCredibilityColor = (score) => {
    if (score >= 80) return "#28a745";
    if (score >= 50) return "#ffc107";
    return "#dc3545";
  };

  const atsData = result?.ats_score !== undefined && result?.ats_score !== null
  ? [{ name: "", value: result.ats_score, fill: "#007bff" }]
  : [];
  return (
    <div className="container">
      <h2 className="header">CV Analysis Results</h2>
      <form onSubmit={handleUpload} className="upload-form">
        <input
          type="file"
          onChange={(e) => setFile(e.target.files[0])}
          accept=".pdf,.docx"
          className="file-input"
        />
        <button type="submit" disabled={isLoading || !dbPreferences} className="upload-button">
          {isLoading ? "Analyzing..." : "Upload"}
        </button>
      </form>

      {error && (
        <p className="error">
          {typeof error === "object"
            ? error.message || error.error || JSON.stringify(error)
            : error}
        </p>
      )}
      {!dbPreferences && (
        <div className="alert alert-warning mt-3">
          <p>Please complete your job preferences for better CV analysis results.</p>
          <button onClick={() => navigate("/jobseeker/preferences")} className="btn btn-sm btn-primary mt-2">
            Complete Preferences Now
          </button>
        </div>
      )}

      {result && (
        <div className="results">
          <div className="ats-score" style={{ marginBottom: "2rem", position: "relative", width: 300, height: 300 }}>
            {atsData.length > 0 ? (
              <>
                <RadialBarChart
                  width={300}
                  height={250}
                  innerRadius="70%"
                  outerRadius="100%"
                  data={atsData}
                  startAngle={90}
                  endAngle={-270}
                >
                  <RadialBar
                    minAngle={15}
                    background
                    clockWise
                    dataKey="value"
                    cornerRadius={10}
                    label={false}
                  />
                  <Legend iconSize={10} layout="vertical" verticalAlign="middle" align="right" />
                </RadialBarChart>
                <div
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%, -50%)",
                    textAlign: "center",
                    pointerEvents: "none",
                    userSelect: "none",
                  }}
                >
                  <div style={{ fontSize: 20, fontWeight: "bold", marginBottom: 210 , color: "#333" }}>
                    ATS Score
                  </div>
                  <div style={{ fontSize: 36, fontWeight: "bold", color: "#007bff" }}>
                    {`${atsData[0].value}%`}
                  </div>
                </div>
              </>
            ) : (
              <p className="score">N/A</p>
            )}
          </div>

          <div className="overview">
            <h3>Overview</h3>
            <p>{result?.overview || "No overview available."}</p>
          </div>

          <div className="strengths">
            <h3>Top Strengths</h3>
            <ul>
              {result?.strengths && typeof result.strengths === "string"
                ? result.strengths.split("\n").slice(0, 10).map((strength, index) => <li key={index}>{strength}</li>)
                : <p>No strengths available.</p>}
            </ul>
          </div>

          <div className="weaknesses">
            <h3>Top Weaknesses</h3>
            <ul>
              {result?.weaknesses && typeof result.weaknesses === "string"
                ? result.weaknesses.split("\n").slice(0, 10).map((weakness, index) => <li key={index}>{weakness}</li>)
                : <p>No weaknesses available.</p>}
            </ul>
          </div>

          <div className="improvements">
            <h3>Improvement Suggestions</h3>
            <ul>
              {result?.suggestions_for_improvement && typeof result.suggestions_for_improvement === "string"
                ? result.suggestions_for_improvement.split("\n").slice(0, 10).map((item, index) => <li key={index}>{item}</li>)
                : <p>No suggestions available.</p>}
            </ul>
          </div>

          <div className="credibility">
            <h3>Credibility Score</h3>
            <p className="score" style={{ color: getCredibilityColor(result.credibility_score || 0) }}>
              {result.credibility_score || "N/A"}
            </p>
          </div>

        </div>
      )}
    </div>
  );
}

export default AtsResult;
