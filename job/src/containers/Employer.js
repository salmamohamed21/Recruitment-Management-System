import React, { Component, useContext } from "react";
import { NavLink, Outlet, useNavigate, useLocation } from "react-router-dom";
import axios from "axios";
import BannerEmployer from "./BannerEmployer";
import { AuthContext } from "../contexts/AuthContext"; // تأكد من استيراد AuthContext
import { apiPath } from "../utils/Consts";

class Employer extends Component {
  state = {
    total_applicants: null,
    total_jobs_posted: null,
    cover: "",
    logo: "",
  };

  componentDidMount() {
    // Removed fetchData call here to avoid calling before auth.email is available
  }

  componentDidUpdate(prevProps) {
    if (
      this.props.auth &&
      this.props.auth.email &&
      prevProps.auth &&
      !prevProps.auth.email &&
      prevProps.auth.email !== this.props.auth.email
    ) {
      this.fetchData();
    }
  }

  fetchData = () => {
    const { email } = this.props.auth; // الحصول على البريد الإلكتروني من حالة المصادقة
    if (!email) {
      console.warn("Email is undefined or empty, skipping fetchData API call.");
      return;
    }
    // Fetch employer data
    axios
      .get(`${apiPath}/employers?email=${email}`)
      .then((response) => {
        console.log("Employer data response:", response.data);
        if (response.data.length > 0) {
          const employer = response.data[0];
          this.setState({
            total_jobs_posted: employer.total_jobs_posted,
            cover: employer.cover && employer.cover.startsWith("http") ? employer.cover : `${apiPath}${employer.cover.startsWith("/media") ? employer.cover : "/media" + employer.cover}`,
            logo: employer.logo && employer.logo.startsWith("http") ? employer.logo : `${apiPath}${employer.logo.startsWith("/media") ? employer.logo : "/media" + employer.logo}`,
          });
        }
      })
      .catch((error) => {
        console.log(error);
      });

    // Fetch total Gemini suggestions count
    axios
      .get(`${apiPath}/get_total_gemini_suggestions`, {
        headers: {
          Authorization: `Bearer ${this.props.auth.token}`,
        },
      })
      .then((response) => {
        console.log("Gemini suggestions response:", response.data);
        if (response.data.total_gemini_suggestions !== undefined) {
          this.setState({
            total_applicants: response.data.total_gemini_suggestions,
          });
        }
      })
      .catch((error) => {
        console.log("Error fetching Gemini suggestions count:", error);
      });
  };

  changeLogoAndCover = (logo, cover) => {
    this.setState({
      logo,
      cover,
    });
  };

  componentDidUpdate(prevProps, prevState) {
    // If logo or cover changed, update BannerEmployer by forcing re-render
    if (prevState.logo !== this.state.logo || prevState.cover !== this.state.cover) {
      this.forceUpdate();
    }
  }

  render() {
    const { total_jobs_posted, total_applicants } = this.state;
    return (
      <div>
        <BannerEmployer cover={this.state.cover} logo={this.state.logo} />

        <section className="company-content-wrapper ">
          <div className="Container">
            <div className="row no-gutters justify-content-between">
              <div className="col-lg-3">
                <div className="profile-pic" id="profilePic">
                  <div className="jobseeker-nav-pill">
                    <NavLink to="/employer/editemployerprofile">
                      Edit profile
                    </NavLink>
                  </div>
                  <div className="jobseeker-nav-pill">
                    <NavLink to="/employer/postnewjob">
                      Post a new job
                    </NavLink>
                  </div>
                  <div className="jobseeker-nav-pill">
                    <NavLink to="/employer/viewpostedjobs">
                      View posted jobs
                    </NavLink>
                  </div>
                </div>
              </div>
              <div className="col-lg-9">
              {/*
              {this.props.location.pathname === "/employer" ? (
                <EmployerLanding
                  totalJobsPosted={total_jobs_posted}
                  totalApplicants={total_applicants}
                  fetchData={this.fetchData}
                />
              ) : (
                <Outlet context={{ changeLogoAndCover: this.changeLogoAndCover }} />
              )}
              */}
              <Outlet context={{ changeLogoAndCover: this.changeLogoAndCover }} />
              </div>
            </div>
          </div>
        </section>
      </div>
    );
  }
}

const EmployerWithRouter = (props) => {
  const navigate = useNavigate();
  const location = useLocation();
  const auth = useContext(AuthContext); // الحصول على حالة المصادقة من السياق
  return <Employer {...props} navigate={navigate} location={location} auth={auth} />;
};

export default EmployerWithRouter;
