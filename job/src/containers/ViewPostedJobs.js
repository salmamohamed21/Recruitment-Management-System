// src/components/ViewJobPosted.js
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import axiosInstance from "../utils/axiosInstance";
import SingleJob from "./ViewSingleJob";
import { confirmDelete } from "../utils/Helpers";
import { apiPath } from "../utils/Consts";
import Loader from "./Loader";
import ErrorMessage from "../components/ErrorMessage";

const ViewJobPosted = () => {
  const [jobs, setJobs] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchJobs = async () => {
      try {
        const response = await axiosInstance.get(`${apiPath}/employer/view-posted-jobs/`);
        if (response.data.resp === 1) {
          setJobs(response.data.jobs);
        } else {
          setError("Failed to load jobs.");
        }
      } catch (err) {
        setError("An error occurred while fetching jobs.");
      } finally {
        setIsLoading(false);
      }
    };
    fetchJobs();
  }, []);

  const deleteJob = async (id) => {
    if (confirmDelete()) {
      try {
        const response = await axiosInstance.delete(`${apiPath}/employer/delete-job/${id}/`);
        if (response.data.resp === 1) {
          alert("Successfully Deleted");
          setJobs(jobs.filter((item) => item.id !== id));
        } else {
          setError("Failed to delete job.");
        }
      } catch (err) {
        setError("An error occurred while deleting the job.");
      }
    }
  };

  const handleViewApplicants = (jobId) => {
    navigate(`/employer/viewjobapplicants/${jobId}`);
  };

  return (
    <div className="job-applied-wrapper table-responsive-md" id="view-job-posted">
      {isLoading && <Loader />}
      {error && <ErrorMessage errorMessage={error} />}

      {!isLoading && (
        <table className="table table-striped">
          <thead>
            <tr>
              <th>S.N</th>
              <th>Job Title</th>
              <th>Total Suggestions</th>
              <th>Category</th>
              <th>Expiry Date</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {jobs.length ? (
              jobs.map((item, index) => (
                <tr key={item.id}>
                  <th>{index + 1}</th>
                  <td>
                    <a
                      href={`/employer/viewjobapplicants/${item.id}`}
                      onClick={(e) => {
                        e.preventDefault();
                        handleViewApplicants(item.id);
                      }}
                      style={{ color: "blue", textDecoration: "underline", cursor: "pointer" }}
                    >
                      {item.title}
                    </a>
                  </td>
                  <td>{item.suggestions_count}</td>
                  <td>{item.category}</td>
                  <td>{item.expiry_date}</td>
                  <td>
                    <SingleJob divId={`singlejob${index}`} job={item} />
                    <button
                      className="btn btn-danger btn-xs"
                      title="Remove Job"
                      onClick={() => deleteJob(item.id)}
                    >
                      <i className="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="6">No jobs posted yet</td>
              </tr>
            )}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default ViewJobPosted;