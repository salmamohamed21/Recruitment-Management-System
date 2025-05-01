import React, { Component } from "react";
import axios from "axios";
import { AuthContext } from "../contexts/AuthContext";
import { apiPath } from "../utils/Consts";
import placeholderImage from "../images/jobseeker-profile.png";

class EditJobSeekerProfile extends Component {
  static contextType = AuthContext;

  constructor(props) {
    super(props);
    this.state = {
      full_name: "",
      email: "",
      phone: "",
      country: "",
      work_mode: "",
      preferred_job_type: "",
      preferred_location: "",
      salary_expectation: "",
      experience_level: "",
      profile_image: null,
      profile_image_label: "Upload Profile Image",
      profile_image_url: null,
      profile_image_preview_url: null,
      error: null,
    };
  }

  componentDidMount() {
    const { auth } = this.context;
    if (!auth.email || !auth.token) {
      this.setState({ error: "Please log in to edit your profile." });
      return;
    }

    axios
      .get(`${apiPath}/jobseeker/profile/update/`, {
        headers: { Authorization: `Bearer ${auth.token}` },
      })
      .then((response) => {
        const user = response.data.user;
        this.setState({
          full_name: user.full_name || "",
          email: user.email || "",
          phone: user.phone || "",
          country: user.country || "",
          work_mode: user.work_mode || "",
          preferred_job_type: user.preferred_job_type || "",
          preferred_location: user.preferred_location || "",
          salary_expectation: user.salary_expectation || "",
          experience_level: user.experience_level || "",
          profile_image_label: user.profile_image ? user.profile_image.split("/").pop() : "Upload Profile Image",
          profile_image_url: user.profile_image
            ? user.profile_image.startsWith('http')
              ? `${user.profile_image}?t=${Date.now()}`
              : `${apiPath.endsWith('/') ? apiPath : apiPath + '/'}${user.profile_image}?t=${Date.now()}`
            : null,
          profile_image_preview_url: null,
        });
      })
      .catch((error) => {
        this.setState({ error: "Failed to load profile." });
      });
  }

  handleChange = (e) => {
    if (e.target.name === "profile_image") {
      if (e.target.files.length > 0) {
        const file = e.target.files[0];
        const previewUrl = URL.createObjectURL(file);
        this.setState({
          profile_image: file,
          profile_image_label: file.name,
          profile_image_preview_url: previewUrl,
        });
      } else {
        this.setState({
          profile_image: null,
          profile_image_label: "Upload Profile Image",
          profile_image_preview_url: null,
        });
      }
    } else {
      this.setState({ [e.target.name]: e.target.value });
    }
  };

  handleSubmit = (e) => {
    e.preventDefault();
    const { auth } = this.context;
    if (!auth.token) {
      this.setState({ error: "Please log in to edit your profile." });
      return;
    }

    const formData = new FormData();
    formData.append("full_name", this.state.full_name);
    formData.append("email", this.state.email);
    formData.append("phone", this.state.phone);
    formData.append("country", this.state.country);
    formData.append("work_mode", this.state.work_mode);
    formData.append("preferred_job_type", this.state.preferred_job_type);
    formData.append("preferred_location", this.state.preferred_location);
    formData.append("salary_expectation", this.state.salary_expectation);
    formData.append("experience_level", this.state.experience_level);
    if (this.state.profile_image) {
      formData.append("profile_image", this.state.profile_image);
    }

    axios
      .put(`${apiPath}/jobseeker/profile/update/`, formData, {
        headers: {
          Authorization: `Bearer ${auth.token}`,
          "Content-Type": "multipart/form-data",
        },
      })
      .then((response) => {
        alert("Profile updated successfully");
        const profileImageRaw = response.data.user && response.data.user.profile_image
          ? response.data.user.profile_image
          : null;
        let baseApiPath = apiPath;
        if (baseApiPath.endsWith("/api")) {
          baseApiPath = baseApiPath.slice(0, -4); // remove '/api'
        }
        const profileImageUrl = profileImageRaw
          ? (profileImageRaw.startsWith("http")
            ? `${profileImageRaw}?t=${Date.now()}`
            : `${baseApiPath.endsWith('/') ? baseApiPath : baseApiPath + '/'}${profileImageRaw}?t=${Date.now()}`)
          : null;
        this.setState({
          profile_image_url: profileImageUrl,
          profile_image_label: profileImageUrl ? profileImageUrl.split("/").pop() : "Upload Profile Image",
          profile_image: null,
          profile_image_preview_url: null,
        });
        if (this.props.changeProfile) {
          this.props.changeProfile(profileImageUrl);
        }
      })
      .catch((error) => {
        this.setState({ error: "Failed to update profile." });
      });
  };

  render() {
    const displayImage = this.state.profile_image_preview_url || this.state.profile_image_url || placeholderImage;

    return (
      <div className="edit-jobseeker-profile">
        {this.state.error && <div className="alert alert-danger">{this.state.error}</div>}
        <form onSubmit={this.handleSubmit} encType="multipart/form-data">
          <div className="form-group">
            <label>Full Name</label>
            <input type="text" name="full_name" value={this.state.full_name} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Email</label>
            <input type="email" name="email" value={this.state.email} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value={this.state.phone} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Country</label>
            <input type="text" name="country" value={this.state.country} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Work Mode</label>
            <input type="text" name="work_mode" value={this.state.work_mode} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Preferred Job Type</label>
            <input type="text" name="preferred_job_type" value={this.state.preferred_job_type} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Preferred Location</label>
            <input type="text" name="preferred_location" value={this.state.preferred_location} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Salary Expectation</label>
            <input type="text" name="salary_expectation" value={this.state.salary_expectation} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Experience Level</label>
            <input type="text" name="experience_level" value={this.state.experience_level} onChange={this.handleChange} className="form-control" />
          </div>
          <div className="form-group">
            <label>Profile Image</label>
            <input type="file" name="profile_image" onChange={this.handleChange} className="form-control-file" />
            <small>{this.state.profile_image_label}</small>
            <div className="mt-2">
              <img
                src={displayImage}
                alt="Profile"
                style={{
                  maxWidth: "200px",
                  maxHeight: "200px",
                  borderRadius: "50%",
                  border: "2px solid #007bff",
                  objectFit: "cover",
                }}
              />
            </div>
          </div>
          <button type="submit" className="btn btn-primary mt-3">Update Profile</button>
        </form>
      </div>
    );
  }
}

export default EditJobSeekerProfile;
