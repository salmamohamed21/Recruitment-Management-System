// src/components/Register.js
import * as React from "react";
import { Link, useNavigate } from "react-router-dom";
import { apiPath } from "../utils/Consts";
import ErrorMessage from "../components/ErrorMessage";
import useErrorHandler from "../utils/custom-hooks/ErrorHandler";
import { validateRegisterForm, printError, removeError } from "../utils/Helpers";
import SignupHeader from "./SignupHeader";
import Axios from "axios";
import { AuthContext } from "../contexts/AuthContext";

const Register = () => {
  const [userEmail, setUserEmail] = React.useState("");
  const [userPassword, setUserPassword] = React.useState("");
  const [userConfirmPassword, setConfirmPassword] = React.useState("");
  const [userEntity, setUserEntity] = React.useState("jobseeker");
  const [country, setCountry] = React.useState("");
  const [phone, setPhone] = React.useState("");
  const [companyName, setCompanyName] = React.useState("");
  const [companyDesc, setCompanyDesc] = React.useState("");
  const [fullName, setFullName] = React.useState("");
  const [loading, setLoading] = React.useState(false);
  const { error, showError } = useErrorHandler(null);
  const { setAuthStatus } = React.useContext(AuthContext);
  const isUserEntityJobseeker = userEntity === "jobseeker";
  const navigate = useNavigate();

  const registerHandler = async () => {
    setLoading(true);
    removeError();

    try {
      const response = await Axios.post(`http://127.0.0.1:8000/api/register/`, {
        username: userEmail,
        email: userEmail,
        password: userPassword,
        password_confirmation: userConfirmPassword,
        country,
        phone,
        ...(userEntity === 'employer' ? {
          company_name: companyName,
          company_description: companyDesc
        } : {
          full_name: fullName
        }),
        user_type: userEntity === 'jobseeker' ? 'job_seeker' : 'recruiter'
      });

      if (response.data && response.data.token) {
        setAuthStatus({
          email: response.data.email || userEmail,
          entity: userEntity,
          token: response.data.token,
          userId: response.data.user_id
        });

        // Save token and user data to localStorage
        localStorage.setItem('authToken', response.data.token);
        localStorage.setItem('userData', JSON.stringify({
          email: response.data.email || userEmail,
          userType: userEntity,
          userId: response.data.user_id
        }));

        // Clear form fields
        setUserEmail("");
        setUserPassword("");
        setConfirmPassword("");
        setCountry("");
        setPhone("");
        setCompanyName("");
        setCompanyDesc("");
        setFullName("");

        // Redirect based on entity
        if (userEntity === "jobseeker") {
          // Store registration flag in localStorage
          localStorage.setItem("newJobseekerRegistration", "true");
          navigate("/jobseeker/preferences");
        } else {
          alert(response.data.message);
          navigate("/jobseeker/preferences");
        }
      } else {
        showError(response.data.message);
      }
    } catch (err) {
      if (err.response) {
        const { data, status } = err.response;
        if (status === 422) {
          alert("Please correct highlighted errors");
          printError(data);
        } else {
          showError("Registration failed. Please try again.");
        }
      } else {
        showError("An unexpected error occurred.");
      }
    }

    setLoading(false);
  };

  return (
    <div className="login-container">
      <div className="content-wrapper border mt-5">
        <SignupHeader
          action="Register"
          isUserEntityJobseeker={isUserEntityJobseeker}
          setUserEntity={setUserEntity}
        />

        <div className="login-form">
          <form
            onSubmit={(e) => {
              e.preventDefault();
              if (
                validateRegisterForm(
                  userEmail,
                  userPassword,
                  userConfirmPassword,
                  showError
                )
              ) {
                registerHandler();
              }
            }}
          >
            {error && <ErrorMessage errorMessage={error} />}

            {userEntity === 'employer' ? (
              <>
                <div className="form-group my-30">
                  <input
                    type="text"
                    placeholder="Company Name"
                    className="form-control p-4"
                    name="companyName"
                    onChange={(e) => setCompanyName(e.target.value)}
                    value={companyName}
                  />
                </div>
                <div className="form-group my-30">
                  <textarea
                    placeholder="Company Description"
                    className="form-control p-4"
                    name="companyDesc"
                    onChange={(e) => setCompanyDesc(e.target.value)}
                    value={companyDesc}
                  />
                </div>
              </>
            ) : (
              <div className="form-group my-30">
                <input
                  type="text"
                  placeholder="Full Name"
                  className="form-control p-4"
                  name="fullName"
                  onChange={(e) => setFullName(e.target.value)}
                  value={fullName}
                />
              </div>
            )}

            <div className="form-group my-30">
              <input
                type="text"
                placeholder="Country"
                className="form-control p-4"
                name="country"
                onChange={(e) => setCountry(e.target.value)}
                value={country}
              />
            </div>
            <div className="form-group my-30">
              <input
                type="tel"
                placeholder="Phone Number"
                className="form-control p-4"
                name="phone"
                onChange={(e) => setPhone(e.target.value)}
                value={phone}
              />
            </div>
            <div className="form-group my-30">
              <input
                type="email"
                name="email"
                placeholder="Email Address"
                className="form-control p-4"
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

            <div className="form-group my-30">
              <input
                type="password"
                placeholder="Confirm Password"
                className="form-control p-4"
                name="password_confirmation"
                onChange={(e) => setConfirmPassword(e.target.value)}
                value={userConfirmPassword}
              />
            </div>

            <div className="form-submit text-center mt-30 mb-3">
              <button className="primary submit" disabled={loading}>
                {loading ? "Loading..." : "Submit"}
              </button>
            </div>

            <div className="here text-center">
              Already have an account? Login{" "}
              <Link to="/login">
                <u>here</u>
              </Link>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Register;
