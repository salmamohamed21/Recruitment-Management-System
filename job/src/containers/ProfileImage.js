import React, { useState, useEffect, useContext } from "react";
import JobseekerProfile from "../images/jobseeker-profile.png";
import { AuthContext } from "../contexts/AuthContext";
import axios from "axios";
import { apiPath } from "../utils/Consts";

const ProfileImage = () => {
  const [profileImageUrl, setProfileImageUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const auth = useContext(AuthContext) || {};
  const { auth: authState } = useContext(AuthContext) || {};

  useEffect(() => {
    if (!authState || !authState.token) {
      setError("No auth token available");
      return;
    }

    if (authState.profileImageUrl) {
      setProfileImageUrl(authState.profileImageUrl);
      setLoading(false);
      setError(null);
      return;
    }

    setLoading(true);
    axios
      .get(`${apiPath}/jobseeker/profile/image/`, {
        headers: { Authorization: `Bearer ${authState.token}` },
      })
      .then((response) => {
        const url = response.data.profile_image_url;
        setProfileImageUrl(url || "");
        setLoading(false);
        setError(null);
      })
      .catch((err) => {
        setError("Failed to load profile image");
        setLoading(false);
      });
  }, [authState]);

  const handleImageError = (e) => {
    e.target.onerror = null;
    e.target.src = JobseekerProfile;
  };

  if (loading) return <p>Loading profile image...</p>;
  if (error) return <p style={{ color: "red" }}>{error}</p>;

  return (
    <img
      src={profileImageUrl || JobseekerProfile}
      alt="Profile"
      style={{
        maxWidth: "200px",
        maxHeight: "200px",
        borderRadius: "50%",
        border: "2px solid #007bff",
        objectFit: "cover",
      }}
      onError={handleImageError}
    />
  );
};

export default ProfileImage;
