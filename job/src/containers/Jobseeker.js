import React, { Component, useContext } from "react";
import { NavLink, Outlet, useNavigate, useLocation, Navigate } from "react-router-dom";
import axios from "axios";
import JobseekerProfile from "../images/jobseeker-profile.png";
import { ProfileImg } from "../components/Styles";
import { AuthContext } from "../contexts/AuthContext";
import { apiPath } from "../utils/Consts"; // استيراد apiPath
import ProfileImage from "./ProfileImage";

class Jobseeker extends Component {
  state = {
    jobs: [],
    redirectToLogin: false,
  };

  componentDidMount() {
    const { auth } = this.props || {};

    if (!auth || !auth.token) {
      console.error("Auth token is undefined in AuthContext");
      // Do not redirect here, let PrivateRoute handle it
      return;
    }

    // جلب بيانات المستخدم
    axios
      .get(`${apiPath}/jobseeker/profile/update/`, {
        headers: { Authorization: `Bearer ${auth.token}` },
      })
      .then((response) => {
        const user = response.data.user;
        console.log("Jobseeker user object:", user);
        this.setState({
          jobs: user.jobs || [],
        });
      })
      .catch((error) => {
        console.log(error);
      });

    // Check preferences in localStorage first
    const preferences = localStorage.getItem("userPreferences");
    if (!preferences) {
      this.props.navigate("/jobseeker/preferences");
    }
    this.setState({ preferencesCompleted: !!preferences });
  }

  componentDidUpdate(prevProps) {
    if ((!prevProps.auth || !prevProps.auth.token) && this.props.auth && this.props.auth.token) {
      // Auth token became available, re-run componentDidMount logic
      this.componentDidMount();
    }
  }

  changeProfile = (profileUrl) => {
    const { auth, setAuthStatus } = this.props;
    if (setAuthStatus && auth) {
      setAuthStatus({
        ...auth,
        profileImageUrl: profileUrl,
      });
    }
  };

  render() {
    if (this.state.redirectToLogin) {
      return <Navigate to="/login" replace={true} />;
    }

    const profileImageStyle = {
      maxWidth: "200px",
      maxHeight: "200px",
      borderRadius: "50%",
      border: "2px solid #007bff",
      objectFit: "cover",
    };

    return (
      <section className="company-content-wrapper">
        <div className="Container">
          <div className="row no-gutters justify-content-between">
            <div className="col-lg-3">
              <div className="profile-pic" id="profilePic">
                <ProfileImage />
              </div>

              <div className="jobseeker-nav">
                <div className="jobseeker-nav-pill">
                  <NavLink to="/jobseeker" end>
                    View applied jobs
                  </NavLink>
                </div>
                <div className="jobseeker-nav-pill">
                  <NavLink to="/jobseeker/editjobseekerprofile">
                    Edit profile
                  </NavLink>
                </div>
                <div className="jobseeker-nav-pill">
                  <NavLink to="/create-cv">Create CV</NavLink>
                </div>
                <div className="jobseeker-nav-pill">
                  <NavLink to="/jobseeker/AtsResult">
                    Upload CV
                  </NavLink>
                </div>
                
              </div>
            </div>
            <div className="col-lg-9">
              <Outlet context={{ changeProfile: this.changeProfile, auth: this.props.auth, setAuthStatus: this.props.setAuthStatus }} />
            </div>
          </div>
        </div>
      </section>
    );
  }
}

const JobseekerWithRouter = (props) => {
  const navigate = useNavigate();
  const location = useLocation();
  const auth = useContext(AuthContext) || {};
  return <Jobseeker {...props} navigate={navigate} location={location} auth={auth} />;
};

export default JobseekerWithRouter;
