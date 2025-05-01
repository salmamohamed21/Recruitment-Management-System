import React, { useState, useContext } from "react";
import axios from "axios";
import { printError, removeError } from "../utils/Helpers";
import { AuthContext } from "../contexts/AuthContext";
import { apiPath } from "../utils/Consts";

const makeRequestWithRefresh = async (axiosConfig, auth, refreshToken, setUnauthStatus) => {
  try {
    axiosConfig.headers = axiosConfig.headers || {};
    axiosConfig.headers.Authorization = `Bearer ${auth.token}`;
    const response = await axios(axiosConfig);
    return response;
  } catch (error) {
    if (error.response && error.response.status === 401) {
      const newToken = await refreshToken();
      if (newToken) {
        axiosConfig.headers.Authorization = `Bearer ${newToken}`;
        return await axios(axiosConfig);
      } else {
        setUnauthStatus();
        window.location.href = "/login";
        throw new Error("Session expired. Please log in again.");
      }
    }
    throw error;
  }
};

const ChangePassword = () => {
  const [oldPassword, setOldPassword] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errors, setErrors] = useState({});
  const { auth, refreshToken, setUnauthStatus } = useContext(AuthContext);

  const handleSubmit = async (e) => {
    e.preventDefault();
    removeError();
    setErrors({});

    if (!auth.token) {
      setErrors({ general: "Please log in to change your password." });
      return;
    }

    // التحقق من أن الحقول ليست فارغة
    const newErrors = {};
    if (!oldPassword) newErrors.old_password = "Old password is required";
    if (!password) newErrors.password = "New password is required";
    if (!confirmPassword) newErrors.password_confirmation = "Confirm password is required";

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    // التحقق من الحد الأدنى للطول لكلمة المرور
    if (password.length < 8) {
      setErrors({ password: "New password must be at least 8 characters long" });
      return;
    }

    // التحقق من تطابق كلمة المرور
    if (password !== confirmPassword) {
      setErrors({ password_confirmation: "New password and confirmation do not match" });
      return;
    }

    try {
      const response = await makeRequestWithRefresh(
        {
          method: "post",
          url: `${apiPath}/change-password/`,
          data: {
            password,
            old_password: oldPassword,
            password_confirmation: confirmPassword,
            entity: auth.entity,
          },
        },
        auth,
        refreshToken,
        setUnauthStatus
      );

      if (response.data.resp === 1) {
        alert("Password successfully changed. You will be logged out.");
        setUnauthStatus(); // تسجيل الخروج
        window.location.href = "/login"; // إعادة التوجيه إلى صفحة تسجيل الدخول
      } else {
        setErrors({ general: "Request Failed" });
      }
    } catch (error) {
      console.error("Change password failed:", error.response?.data || error.message);
      if (error.response && error.response.status === 422) {
        printError(error.response.data);
      } else if (error.response && error.response.status === 400) {
        if (error.response.data.errors) {
          setErrors(error.response.data.errors);
        } else {
          setErrors({ general: error.response.data.error || "Failed to change password" });
        }
      } else {
        setErrors({ general: error.message || "Failed to change password" });
      }
    }
  };

  return (
    <div>
      <form action="" onSubmit={handleSubmit} id="changePassForm">
        {errors.general && <div className="alert alert-danger">{errors.general}</div>}

        <div className="form-group my-30">
          <input
            type="password"
            name="old_password"
            placeholder="Old password"
            className={`form-control p-3 ${errors.old_password ? "is-invalid" : ""}`}
            onChange={(e) => setOldPassword(e.target.value)}
            value={oldPassword}
          />
          {errors.old_password && (
            <div className="invalid-feedback">{errors.old_password}</div>
          )}
        </div>

        <div className="form-group my-30">
          <input
            type="password"
            name="password"
            placeholder="New password"
            className={`form-control p-3 ${errors.password ? "is-invalid" : ""}`}
            onChange={(e) => setPassword(e.target.value)}
            value={password}
          />
          {errors.password && (
            <div className="invalid-feedback">{errors.password}</div>
          )}
        </div>

        <div className="form-group my-30">
          <input
            type="password"
            name="password_confirmation"
            placeholder="Confirm Password"
            className={`form-control p-3 ${errors.password_confirmation ? "is-invalid" : ""}`}
            onChange={(e) => setConfirmPassword(e.target.value)}
            value={confirmPassword}
          />
          {errors.password_confirmation && (
            <div className="invalid-feedback">{errors.password_confirmation}</div>
          )}
        </div>

        <div className="form-group">
          <button type="submit" className="post-job-btn b-0 px-3 primary">
            Submit
          </button>
        </div>
      </form>
    </div>
  );
};

export default ChangePassword;