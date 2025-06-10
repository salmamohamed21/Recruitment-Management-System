import * as React from "react";
import { Link, useNavigate } from "react-router-dom";
import axios from "axios";
import SignupHeader from "./SignupHeader";
/** Presentation */
import ErrorMessage from "../components/ErrorMessage";
/** Custom Hooks */
import useErrorHandler from "../utils/custom-hooks/ErrorHandler";
/** Context */
import { AuthContext } from "../contexts/AuthContext";
/** Utils */
import { validateLoginForm, removeError } from "../utils/Helpers";
import { apiPath } from "../utils/Consts"; // استيراد apiPath من Consts.js

const Login = () => {
  const { setAuthStatus } = React.useContext(AuthContext);
  const [userEmail, setUserEmail] = React.useState("");
  const [userPassword, setUserPassword] = React.useState("");
  const [userEntity, setUserEntity] = React.useState("jobseeker");
  const [loading, setLoading] = React.useState(false);
  const { error, showError } = useErrorHandler(null);
  const isUserEntityJobseeker = userEntity === "jobseeker" ? true : false;
  const navigate = useNavigate();

  const authHandler = async () => {
    setLoading(true);
    removeError();

    try {
      const response = await axios.post(`${apiPath}/login_user/`, {
        email: userEmail,
        password: userPassword,
        user_type: userEntity,
      });

      const data = response.data;
      console.log("Login response data:", data); // Debug response

      if (data.access) {
        // حفظ التوكن والبيانات في AuthContext
        const authData = {
          email: userEmail,
          entity: userEntity,
          token: data.access,
          refreshToken: data.refresh, // include refreshToken
          userId: data.user_id, // add userId from backend response
          profileImageUrl: data.profile_image_url || null, // add profile image URL
          logoUrl: data.company_logo || null, // add company logo URL
          coverUrl: data.company_cover || null, // add company cover URL
        };
        setAuthStatus(authData);

        // تخزين التوكن والبيانات في localStorage ليتوافق مع AuthContext
        localStorage.setItem("accessToken", data.access);
        localStorage.setItem("refreshToken", data.refresh);
        localStorage.setItem("userEmail", userEmail);
        localStorage.setItem("userType", userEntity);
        localStorage.setItem("userId", data.user_id);
        if (data.profile_image_url) {
          localStorage.setItem("profileImageUrl", data.profile_image_url);
        }
        if (data.company_logo) {
          localStorage.setItem("logoUrl", data.company_logo);
        }
        if (data.company_cover) {
          localStorage.setItem("coverUrl", data.company_cover);
        }

        console.log("Auth data set in localStorage:", authData); // Debug localStorage

        // التحويل بناءً على نوع المستخدم
        if (userEntity === "recruiter") {
          navigate("/employer");
        } else if (userEntity === "jobseeker") { // fix userEntity value consistency
          navigate("/ats-result"); // Redirect to AtsResult page for job seekers
        }
      } else {
        showError("Invalid email or password");
      }
    } catch (err) {
      console.error("Login error:", err);
      showError(
        err.response?.data?.detail || err.response?.data?.error || "Error logging in. Please try again."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="content-wrapper border mt-5">
        <SignupHeader
          action="Login"
          isUserEntityJobseeker={isUserEntityJobseeker}
          setUserEntity={setUserEntity}
        />

        <div className="login-form">
          <form
            onSubmit={(e) => {
              e.preventDefault();
              if (validateLoginForm(userEmail, userPassword, showError)) {
                authHandler();
              }
            }}
          >
            {error && <ErrorMessage errorMessage={error} />}

            <div className="form-group my-30">
              <input
                type="email"
                placeholder="Email Address"
                className="form-control p-4"
                name="email"
                onChange={(e) => setUserEmail(e.target.value)}
                value={userEmail}
              />
            </div>
            <div className="form-group my-30">
              <input
                type="password"
                placeholder="Password"
                className="form-control p-4"
                name="password"
                onChange={(e) => setUserPassword(e.target.value)}
                value={userPassword}
              />
            </div>

            <div className="forgot-password-link text-right mb-3">
              <Link to="/forgot-password">
                <u>Forgot Password?</u>
              </Link>
            </div>

            <div className="form-submit text-center mt-30 mb-3">
              <button className="primary submit" disabled={loading}>
                {loading ? "Loading..." : "Submit"}
              </button>
            </div>
            <div className="here text-center">
              Don't have an account? Register{" "}
              <Link to="/register">
                <u>here</u>
              </Link>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Login;
