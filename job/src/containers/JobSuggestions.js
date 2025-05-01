import React, { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import axios from "axios";
import SuggestionsList from "../components/SuggestionsList";

const JobSuggestions = () => {
  const location = useLocation();
  const [suggestions, setSuggestions] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    console.log("Fetching suggestions with:", location.state);
    const fetchSuggestions = async () => {
      try {
        const response = await axios.post(
          "http://127.0.0.1:8000/job-suggestions",
          { title: location.state.title, description: location.state.description }
        );
        console.log("Received suggestions:", response.data.data); 

        setSuggestions(response.data.data || []);
      } catch (error) {
        console.error("Error fetching suggestions:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchSuggestions();
  }, [location.state]);

  return (
    <div className="container mt-5">
      <h2>Job Suggestions</h2>
      {loading ? (
        <p>Loading suggestions...</p>
      ) : (
        <SuggestionsList suggestions={suggestions} />
      )}
    </div>
  );
};

export default JobSuggestions;
