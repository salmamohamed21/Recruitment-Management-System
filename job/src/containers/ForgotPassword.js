import * as React from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { apiPath } from "../utils/Consts";
import ErrorMessage from "../components/ErrorMessage";

const ForgotPassword = () => {
  const [step, setStep] = React.useState(1);
  const [email, setEmail] = React.useState("");
  const [otpCode, setOtpCode] = React.useState("");
  const [newPassword, setNewPassword] = React.useState("");
  const [confirmPassword, setConfirmPassword] = React.useState("");
  const [loading, setLoading] = React.useState(false);
  const [error, setError] = React.useState(null);
  const navigate = useNavigate();

  const requestOtp = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.post(`${apiPath}/request_password_reset_otp/`, { email });
      setStep(2);
    } catch (err) {
      setError(err.response?.data?.error || "Failed to send OTP. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const verifyOtpAndResetPassword = async () => {
    setLoading(true);
    setError(null);
    if (newPassword !== confirmPassword) {
      setError("New password and confirm password do not match.");
      setLoading(false);
      return;
    }
    if (newPassword.length < 8) {
      setError("New password must be at least 8 characters long.");
      setLoading(false);
      return;
    }
    try {
      const response = await axios.post(`${apiPath}/verify_otp_and_reset_password/`, {
        email,
        otp_code: otpCode,
        new_password: newPassword,
        confirm_password: confirmPassword,
      });
      alert("Password reset successful. Please login with your new password.");
      navigate("/login");
    } catch (err) {
      setError(err.response?.data?.error || "Failed to reset password. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="content-wrapper border mt-5">
        <h2 className="header">Forgot Password</h2>
        {error && <ErrorMessage errorMessage={error} />}
        {step === 1 && (
          <>
            <p>Enter your email address to receive an OTP for password reset.</p>
            <input
              type="email"
              placeholder="Email Address"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="form-control"
            />
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '10px' }}>
              <button className="primary submit" onClick={requestOtp} disabled={loading || !email}>
                {loading ? "Sending OTP..." : "Send OTP"}
              </button>
              <button className="primary submit" onClick={() => navigate("/login")}>
                Cancel
              </button>
            </div>
          </>
        )}
        {step === 2 && (
          <>
            <p>Enter the OTP sent to your email and your new password.</p>
            <input
              type="text"
              placeholder="OTP Code"
              value={otpCode}
              onChange={(e) => setOtpCode(e.target.value)}
              className="form-control"
            />
            <input
              type="password"
              placeholder="New Password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              className="form-control"
            />
            <input
              type="password"
              placeholder="Confirm New Password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="form-control"
            />
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '10px' }}>
              <button className="primary submit" onClick={verifyOtpAndResetPassword} disabled={loading || !otpCode || !newPassword || !confirmPassword}>
                {loading ? "Resetting Password..." : "Reset Password"}
              </button>
              <button className="primary submit" onClick={() => navigate("/login")}>
                Cancel
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default ForgotPassword;
