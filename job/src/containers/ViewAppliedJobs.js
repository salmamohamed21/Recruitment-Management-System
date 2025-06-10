import React, { Component } from "react";
import SingleJob from "./ViewSingleJob";
import axios from "axios";
import ViewJobSeekerDetails from "./ViewJobSeekerDetails";
import { useNavigate } from "react-router-dom";

class ViewAppliedJobs extends Component {
  constructor(props) {
    super(props);
    this.state = {
      suggestedJobs: [],
      acceptedJobs: [],
      selectedJobSeeker: null,
      viewDetails: false,
      isLoading: true,
      error: null,
      isLoadingSuggested: true,
      errorSuggested: null,
    };
  }

  componentDidMount() {
    this.fetchAcceptedJobs();
    this.fetchSuggestedJobs();
  }

  fetchAcceptedJobs = () => {
    const apiPath = process.env.REACT_APP_API_URL;
    const token = localStorage.getItem("accessToken");
    axios
      .get(apiPath + "/accepted-jobs/", {
        headers: {
          Authorization: token ? `Bearer ${token}` : "",
        },
      })
      .then((response) => {
        if (response.data.resp === 1) {
          console.log("Accepted Jobs Data:", response.data.accepted_jobs);
          this.setState({ acceptedJobs: response.data.accepted_jobs, isLoading: false });
        } else {
          this.setState({ error: "Failed to load accepted jobs.", isLoading: false });
        }
      })
      .catch((error) => {
        this.setState({ error: "An error occurred while fetching accepted jobs.", isLoading: false });
      });
  };

  fetchSuggestedJobs = () => {
    const apiPath = process.env.REACT_APP_API_URL;
    const token = localStorage.getItem("accessToken");
    axios
      .get(apiPath + "/suggested-jobs/", {
        headers: {
          Authorization: token ? `Bearer ${token}` : "",
        },
      })
      .then((response) => {
        if (response.data.resp === 1) {
          console.log("Suggested Jobs Data:", response.data.suggested_jobs);
          this.setState({ suggestedJobs: response.data.suggested_jobs, isLoadingSuggested: false });
        } else {
          this.setState({ errorSuggested: "Failed to load suggested jobs.", isLoadingSuggested: false });
        }
      })
      .catch((error) => {
        this.setState({ errorSuggested: "An error occurred while fetching suggested jobs.", isLoadingSuggested: false });
      });
  };

  handleJobClick = (jobId) => {
    const apiPath = process.env.REACT_APP_API_URL;
    const token = localStorage.getItem("accessToken");
    // Fetch detailed job info and company info from two endpoints
    const jobDetailsRequest = axios.get(`${apiPath}/jobseeker/job/${jobId}/`, {
      headers: { Authorization: token ? `Bearer ${token}` : "" },
    });
    const companyDetailsRequest = axios.get(`${apiPath}/jobseeker/job-company-details/${jobId}/`, {
      headers: { Authorization: token ? `Bearer ${token}` : "" },
    });

    Promise.all([jobDetailsRequest, companyDetailsRequest])
      .then(([jobRes, companyRes]) => {
        if (jobRes.data && companyRes.data) {
          console.log("Detailed job info:", jobRes.data);
          console.log("Company info:", companyRes.data);
          // Combine job and company data into one object
          const combinedData = {
            job: jobRes.data.job,
            company: companyRes.data.company,
          };
          this.setState({ selectedJob: combinedData });
        }
      })
      .catch((err) => {
        console.error("Error fetching job or company details:", err);
      });
  };

  rejectSuggestedJob = (jobId) => {
    if (!window.confirm("Are you sure you want to reject this job?")) {
      return;
    }
    const apiPath = process.env.REACT_APP_API_URL;
    const token = localStorage.getItem("accessToken");
    axios
      .post(
        apiPath + "/reject-suggested-job/",
        { job_id: jobId },
        {
          headers: {
            Authorization: token ? `Bearer ${token}` : "",
          },
        }
      )
      .then((response) => {
        if (response.status === 200) {
          // Remove the rejected job from suggestedJobs state
          this.setState((prevState) => ({
            suggestedJobs: prevState.suggestedJobs.filter((job) => job.job.id !== jobId),
          }));
        } else {
          alert("Failed to reject the suggested job.");
        }
      })
      .catch((error) => {
        alert("An error occurred while rejecting the suggested job.");
      });
  };

  render() {
    const {
      acceptedJobs,
      isLoading,
      error,
      selectedJob,
      suggestedJobs,
      isLoadingSuggested,
      errorSuggested,
    } = this.state;

    // Filter suggested jobs to only those with state === "suggested"
    const filteredSuggestedJobs = suggestedJobs.filter(job => job.state === "suggested");

    // Filter accepted jobs to only those with state === "accepted"
    const filteredAcceptedJobs = acceptedJobs.filter(job => job.state === "accepted");

    if (selectedJob) {
      const { job, company } = selectedJob;
      return (
        <div className="job-details-view">
          <button
            className="btn btn-secondary mb-3"
            onClick={() => this.setState({ selectedJob: null })}
          >
            Back to Applied Jobs
          </button>
          <div className="row justify-content-around job-page-wrapper mb-5 mx-0">
            <div className="col-lg-3">
              <div className="employer-detail-box">
                <h5 className="mb-3 mr-5">Company Details</h5>
                <ul>
                  <li>
                    Name: <span>{company.name}</span>
                  </li>
                  <li>
                    Address: <span>{company.address}</span>
                  </li>
                  <li>
                    Email: <span>{company.email}</span>
                  </li>
                  <li>
                    Phone: <span>{company.phone}</span>
                  </li>
                </ul>
              </div>
            </div>

            <div className="col-lg-8">
              <div className="job-info-container">
                <h5>Basic Job Information</h5>
                <ul>
                  <li>
                    Title: <span>{job.title}</span>
                  </li>
                  <li>
                    Category: <span>{job.category}</span>
                  </li>
                  <li>
                    Level: <span>{job.level}</span>
                  </li>
                  <li>
                    Type: <span>{job.type}</span>
                  </li>
                  <li>
                    Qualification: <span>{job.qualification}</span>
                  </li>
                  <li>
                    Experience: <span>{job.experience}</span>
                  </li>
                  <li>
                    Salary: <span>{job.salary}</span>
                  </li>
                  <li>
                    Deadline: <span>{job.expiry_date}</span>
                  </li>
                </ul>
              </div>
              <div className="job-description-container">
                <h5 className="mb-3">Job Description :</h5>
                <div
                  dangerouslySetInnerHTML={{ __html: job.description }}
                ></div>
              </div>
            </div>
          </div>
        </div>
      );
    }

    return (
      <div className="job-applied-wrapper table-responsive-md" id="view-job-posted">
        <h3>Suggested Jobs</h3>
        {isLoadingSuggested && <div>Loading suggested jobs...</div>}
        {errorSuggested && <div className="error-message">{errorSuggested}</div>}
        {!isLoadingSuggested && !errorSuggested && (
          <table className="table table-striped">
            <thead>
              <tr>
                <th>S.N</th>
                <th>Job Title</th>
                <th>Category</th>
                <th>Expiry Date</th>
                <th>State</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {filteredSuggestedJobs.length ? (
                filteredSuggestedJobs.map((item, index) => (
                  <tr key={item.id}>
                    <th>{index + 1}</th>
                    <td>
                      <a
                        href="#"
                        onClick={(e) => {
                          e.preventDefault();
                          this.handleJobClick(item.job.id);
                        }}
                        style={{ color: "blue", textDecoration: "underline", cursor: "pointer" }}
                      >
                        {item.job.title}
                      </a>
                    </td>
                    <td>{item.job.category}</td>
                    <td>{item.job.expiry_date}</td>
                    <td>{item.state}</td>
                    <td>
                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => this.rejectSuggestedJob(item.job.id)}
                      >
                        Reject
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="6">No suggested jobs available</td>
                </tr>
              )}
            </tbody>
          </table>
        )}

        <h3 className="mt-5">Accepted Jobs</h3>
        {isLoading && <div>Loading accepted jobs...</div>}
        {error && <div className="error-message">{error}</div>}
        {!isLoading && !error && (
          <table className="table table-striped">
            <thead>
              <tr>
                <th>S.N</th>
                <th>Job Title</th>
                <th>Category</th>
                <th>Expiry Date</th>
                <th>State</th>
              </tr>
            </thead>
            <tbody>
              {filteredAcceptedJobs.length ? (
                filteredAcceptedJobs.map((item, index) => (
                  <tr key={item.id}>
                    <th>{index + 1}</th>
                    <td>
                      <a
                        href="#"
                        onClick={(e) => {
                          e.preventDefault();
                          this.handleJobClick(item.job.id);
                        }}
                        style={{ color: "blue", textDecoration: "underline", cursor: "pointer" }}
                      >
                        {item.job.title}
                      </a>
                    </td>
                    <td>{item.job.category}</td>
                    <td>{item.job.expiry_date}</td>
                    <td>{item.state}</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="5">No accepted jobs yet</td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    );
  }
}

function WithNavigate(props) {
  let navigate = useNavigate();
  return <ViewAppliedJobs {...props} navigate={navigate} />;
}

export default WithNavigate;
