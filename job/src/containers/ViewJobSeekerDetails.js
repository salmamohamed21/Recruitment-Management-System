import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axiosInstance from "../utils/axiosInstance";
import Loader from "./Loader";
import { apiPath } from "../utils/Consts";
import JobseekerProfile from "../images/jobseeker-profile.png";


const defaultProfileImage = JobseekerProfile; // Path to default profile image

const handleImageError = (e) => {
    e.target.onerror = null;
    e.target.src = JobseekerProfile;
  };

const ViewJobSeekerDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [jobseeker, setJobseeker] = useState(null);
  const [overviewSections, setOverviewSections] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [detailsResponse, overviewResponse] = await Promise.all([
          axiosInstance.get(`${apiPath}/jobseeker/details/${id}/`),
          axiosInstance.get(`${apiPath}/jobseeker/overview_sections/${id}/`)
        ]);
        setJobseeker(detailsResponse.data);
        setOverviewSections(overviewResponse.data);
      } catch (error) {
        console.error("Failed to fetch jobseeker data:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  if (loading) return <Loader />;

  if (!jobseeker) return <p>Job seeker details not found.</p>;

  return (
    <div className="jobseeker-details" style={styles.container}>
      <button
        onClick={() => navigate(-1)}
        aria-label="Back to Suggestions"
        title="Back to Suggestions"
        style={styles.backButton}
      >
        ←
      </button>
      <h2 style={styles.header}>Job Seeker Details</h2>

      <div style={styles.profileSection}>
        {/* Profile Image */}
        <div style={styles.imageContainer}>
          <img
            src={jobseeker.profile_image || defaultProfileImage}
            alt="Profile"
            style={styles.profileImage}
          />
        </div>

        {/* Contact Information */}
        <div style={styles.contactInfo}>
          <h3 style={styles.subHeader}>{jobseeker.full_name || "No name available."}</h3>
          <p style={styles.contactItem}>
            <span style={styles.icon}>📞</span>
            {jobseeker.phone || "No phone number available."}
          </p>
          <p style={styles.contactItem}>
            <span style={styles.icon}>✉️</span>
            {jobseeker.email || "No email available."}
          </p>
          <p style={styles.contactItem}>
            <span style={styles.icon}>📍</span>
            {jobseeker.country || "No country information available."}
          </p>
          {jobseeker.score !== undefined && (
            <p style={styles.contactItem}>
              <span style={styles.icon}>⭐</span>
              Score: {jobseeker.score}
            </p>
          )}
        </div>
      </div>

      {/* Overview Sections */}
      <section style={styles.overviewSection}>
        <h3 style={styles.subHeader}>Overview</h3>
        {overviewSections ? (
          <>
            {Object.entries(overviewSections).map(([section, content]) => (
              <div key={section} style={styles.overviewItem}>
                <h4 style={styles.sectionTitle}>
                  {section.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}
                </h4>
                <p>{content || `No ${section.replace(/_/g, ' ')} available.`}</p>
              </div>
            ))}
          </>
        ) : (
          <p>No overview sections available.</p>
        )}
      </section>
    </div>
  );
};

// Inline styles for simplicity
const styles = {
  container: {
    maxWidth: "800px",
    margin: "0 auto",
    padding: "20px",
    fontFamily: "Arial, sans-serif",
  },
  backButton: {
    background: "none",
    border: "none",
    fontSize: "24px",
    cursor: "pointer",
    marginBottom: "10px",
  },
  header: {
    fontSize: "28px",
    fontWeight: "bold",
    marginBottom: "20px",
    textAlign: "center",
  },
  profileSection: {
    display: "flex",
    alignItems: "center",
    marginBottom: "30px",
  },
  imageContainer: {
    flex: "0 0 auto",
    marginRight: "20px",
  },
  profileImage: {
    width: "150px",
    height: "150px",
    borderRadius: "50%", // Circular shape
    objectFit: "cover",
  },
  placeholderImage: {
    width: "150px",
    height: "150px",
    borderRadius: "50%", // Circular shape
    backgroundColor: "#f0f0f0",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    color: "#666",
    fontSize: "14px",
  },
  contactInfo: {
    flex: "1",
  },
  subHeader: {
    fontSize: "20px",
    fontWeight: "bold",
    marginBottom: "10px",
  },
  contactItem: {
    fontSize: "16px",
    margin: "5px 0",
    display: "flex",
    alignItems: "center",
  },
  icon: {
    marginRight: "10px",
    fontSize: "18px",
  },
  overviewSection: {
    marginTop: "20px",
  },
  overviewItem: {
    marginBottom: "15px",
  },
  sectionTitle: {
    fontSize: "18px",
    fontWeight: "bold",
    marginBottom: "5px",
  },
};

export default ViewJobSeekerDetails;