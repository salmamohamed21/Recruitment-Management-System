import React, { Component } from "react";
import axiosInstance from "../utils/axiosInstance";
import Loader from "./Loader";
import { apiPath } from "../utils/Consts";
import { useParams, useNavigate } from "react-router-dom";
import ViewJobSeekerDetails from "./ViewJobSeekerDetails";

class ViewJobApplicant extends Component {
  constructor(props) {
    super(props);
    this.state = {
      mlApplicants: [],
      isLoading: true,
      viewDetails: false,
      selectedJobSeeker: null,
      groupedApplicants: {},
    };
  }

  async componentDidMount() {
    if (this.state.isLoading) {
      const jobId = this.props.params?.jobId;
      try {
        // First, call suggest_job_seekers endpoint to generate new suggestions
       // await axiosInstance.post(`${apiPath}/employer/job-suggestions/${jobId}`);

        // Then, fetch existing suggestions from Application table
        const response = await axiosInstance.get(`${apiPath}/employer/view-ml-applicants/${jobId}/`);

        if (response.data.resp === 1 || response.data.ml_applicants) {
          const applicants = response.data.ml_applicants || [];

          // Group by job title
          const grouped = {};
          applicants.forEach((app) => {
            const jobTitle = app.job.title;
            if (!grouped[jobTitle]) {
              grouped[jobTitle] = [];
            }
            grouped[jobTitle].push(app);
          });

          // Sort each group by match_score descending
          Object.keys(grouped).forEach((jobTitle) => {
            grouped[jobTitle].sort((a, b) => b.match_score - a.match_score);
          });

          this.setState({
            mlApplicants: applicants,
            groupedApplicants: grouped,
            isLoading: false,
          });
        }
      } catch (error) {
        console.log(error);
        this.setState({ isLoading: false });
      }
    }
  }

  handleJobSeekerClick = (jobSeeker) => {
    console.log("Clicked jobseeker object:", jobSeeker);
    // Safely get jobseeker id
    const jobseekerId = jobSeeker?.user?.id || jobSeeker?.id || jobSeeker;
    console.log("Navigating to employer viewjobseekerdetails with id:", jobseekerId);
    this.props.navigate(`/employer/viewjobseekerdetails/${jobseekerId}`);
  };

  handleBack = () => {
    this.setState({ selectedJobSeeker: null, viewDetails: false });
  };

  render() {
    if (this.state.viewDetails) {
      return (
        <ViewJobSeekerDetails
          jobseeker={this.state.selectedJobSeeker}
          onBack={this.handleBack}
        />
      );
    }

    return (
      <div
        className="job-applied-wrapper table-responsive-md"
        id="view-job-applicant"
      >
        {this.state.isLoading && <Loader />}

        {!this.state.isLoading && (
          <>
            {Object.keys(this.state.groupedApplicants).length === 0 ? (
              <p>No suitable candidates found</p>
            ) : (
              Object.entries(this.state.groupedApplicants).map(
                ([jobTitle, apps]) => (
                  <div key={jobTitle} className="suggested-job-group">
                    <h4>{jobTitle}</h4>
                    <table className="table table-striped">
                      <thead>
                        <tr>
                          <th>S.N</th>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Matching %</th>
                          <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        {apps.map((app, index) => (
                          <tr key={index}>
                            <td>{index + 1}</td>
                            <td>
                              <button
                                className="btn btn-link p-0"
                                onClick={() =>
                                  this.handleJobSeekerClick(app.jobseeker)
                                }
                              >
                                {app.jobseeker_name}
                              </button>
                            </td>
                            <td>{app.jobseeker_email}</td>
                            <td>{app.match_score.toFixed(2)}</td>
                            <td>
                              {app.state === 'accepted' ? (
                                <button
                                  className="btn btn-success btn-md"
                                  disabled
                                  title="Accepted"
                                >
                                  <i className="fas fa-check"></i>
                                </button>
                              ) : (
                                <button
                                  className="btn btn-success btn-md"
                                  title="Accept Jobseeker"
                                  onClick={async () => {
                                    try {
await axiosInstance.post(
  `${apiPath}/employer/accept-jobseeker/${app.id}/`
);
                                      // Update the state to reflect acceptance
                                      const updatedApplicants = [...this.state.mlApplicants];
                                      const index = updatedApplicants.findIndex(a => a.id === app.id);
                                      if (index !== -1) {
                                        updatedApplicants[index].state = 'accepted';
                                        this.setState({ mlApplicants: updatedApplicants });
                                      }
                                    } catch (error) {
                                      console.error('Error accepting jobseeker:', error);
                                      alert('Failed to accept jobseeker. Please try again.');
                                    }
                                  }}
                                >
                                  <i className="fas fa-check"></i>
                                </button>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )
              )
            )}
          </>
        )}
      </div>
    );
  }
}

const ViewJobApplicantWithParams = (props) => {
  const params = useParams();
  const navigate = useNavigate();
  return <ViewJobApplicant {...props} params={params} navigate={navigate} />;
};

export default ViewJobApplicantWithParams;
