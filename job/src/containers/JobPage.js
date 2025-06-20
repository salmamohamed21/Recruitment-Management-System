import React, { Component } from "react";
import { useNavigate, useLocation, useParams } from "react-router-dom";
import { AuthContext } from "../contexts/AuthContext";
import axios from "axios";
import BannerEmployer from "./BannerEmployer";
import JobPageBanner from "./JobPageBanner";
import Loader from "./Loader";
import { apiPath } from "../utils/Consts";

class JobPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      job: {},
      employer: {
        name: "ABC employer",
        address: "Thamel, Kathmandu",
        phone: "+977-9860536208",
        email: "xyz@abcemployer.com",
        cover: "",
        logo: "",
      },
      isLoading: true,
    };
  }

  static contextType = AuthContext;

  componentDidMount() {
    const { jobId, navigate } = this.props;

    if (!jobId) {
      // Redirect to home if jobId is undefined
      navigate("/");
      return;
    }

    if (this.state.isLoading) {
      const { auth } = this.context;
      const token = auth.token || null;
      axios
        .get(`http://127.0.0.1:8000/api/jobseeker/job-company-details/${jobId}/`, {
          headers: {
            Authorization: token ? `Bearer ${token}` : "",
          },
        })
        .then((response) => {
          if (response.data.resp === 1) {
            console.log(response);
            const jobData = response.data.job || {};
            const employerData = response.data.company || {
              name: "ABC employer",
              address: "Thamel, Kathmandu",
              phone: "+977-9860536208",
              email: "xyz@abcemployer.com",
              cover: "",
              logo: "",
            };
            this.setState({
              job: jobData,
              employer: employerData,
              isLoading: false,
            });
          }
        })
        .catch((error) => {
          console.log(error);
        });
    }
  }

  applyForJob = () => {
    const { auth } = this.context;
    const isAuthenticated = auth.email ? true : false;
  
    if (!isAuthenticated) {
      alert("you must login to apply for jobs");
    } else {
      const apiPath = process.env.REACT_APP_API_URL;
  
      axios
        .post(`${apiPath}/apply-job/${this.state.job.id}/`, {}, {
          headers: {
            Authorization: auth.token ? `Bearer ${auth.token}` : "",
          },
        })
        .then((response) => {
          if (response.data.resp === 1) {
            alert("Successfully applied for job");
          } else if (response.data.resp === 0) {
            alert(response.data.message);
          } else {
            // Do not show "Request Failed" for manual re-application after rejection
            if (response.data.message && response.data.message.includes("under review")) {
              alert(response.data.message);
            } else {
              alert("Request Failed");
            }
          }
        })
        .catch((error) => {
          if (error.response) {
            console.log("Error response data:", error.response.data);
            const errData = error.response.data;
            const errMsg = typeof errData === "object" ? (errData.message || errData.error || JSON.stringify(errData)) : errData;
            alert(errMsg);
          } else {
            console.log(error);
            alert("Request failed");
          }
        });
    }
  };
  
  

  render() {
    const { employer, job } = this.state;
    const { auth } = this.context;
    return (
      <div>
        {this.state.isLoading && <Loader />}

        {!this.state.isLoading && (
          <div>
          <JobPageBanner cover={employer?.cover || ""} logo={employer?.logo || ""} />
            <div className="row justify-content-around job-page-wrapper mb-5 mx-0">
              <div className="col-lg-3">
                <div className="employer-detail-box">
                  <h5 className="mb-3 mr-5">Company Details</h5>
                  <ul>
                    <li>
                      Name: <span>{employer.name}</span>
                    </li>
                    <li>
                      Address: <span>{employer.address}</span>
                    </li>
                    <li>
                      Email: <span>{employer.email}</span>
                    </li>
                    <li>
                      Phone: <span>{employer.phone}</span>
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
                <div className="job-apply-btn">
                  {!(auth.entity === "employer") && (
                    <button
                      type="submit"
                      className="post-job-btn b-0 px-3 primary"
                      onClick={this.applyForJob}
                    >
                      Apply for Job
                    </button>
                  )}
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    );
  }
}

const JobPageWithRouter = (props) => {
  const navigate = useNavigate();
  const location = useLocation();
  const params = useParams();
  return <JobPage {...props} navigate={navigate} location={location} jobId={params.jobId} />;
};

export default JobPageWithRouter;
