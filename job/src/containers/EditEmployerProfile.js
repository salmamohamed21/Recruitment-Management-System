import React, { Component } from "react";
import Editor from "../widgets/Editor";
import axios from "axios";
import { AuthContext } from "../contexts/AuthContext";
import { printError, removeError } from "../utils/Helpers";
import { apiPath } from "../utils/Consts"; // تأكد من أن apiPath = http://127.0.0.1:8000/api

class EditEmployerProfile extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      email: "",
      address: "",
      description: "",
      logo: "",
      cover: "",
      logo_label: "Upload Logo",
      cover_label: "Upload Cover",
      error: null,
    };
  }

  static contextType = AuthContext;

  // دالة مساعدة لإرسال الطلبات مع تحديث التوكن
  makeRequestWithRefresh = async (axiosConfig) => {
    const { auth, refreshToken, setUnauthStatus } = this.context;
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

  componentDidMount() {
    const { auth } = this.context;
    if (!auth.email || !auth.token) {
      this.setState({ error: "Please log in to edit your profile." });
      return;
    }

    this.makeRequestWithRefresh({
      method: "get",
      url: `${apiPath}/recruiter/profile/update/`,
    })
      .then((response) => {
        const baseUrl = apiPath.endsWith("/api") ? apiPath.slice(0, -4) : apiPath;
        const logoUrl = response.data.logo && !response.data.logo.startsWith("http") ? `${baseUrl}${response.data.logo}` : response.data.logo;
        const coverUrl = response.data.cover && !response.data.cover.startsWith("http") ? `${baseUrl}${response.data.cover}` : response.data.cover;
        this.setState({
          name: response.data.name || "",
          email: response.data.email || "",
          address: response.data.address || "",
          description: response.data.description || "",
          logo: response.data.logo || null,
          cover: response.data.cover || null,
          logo_label: response.data.logo ? response.data.logo.split('/').pop() : "Upload Logo",
          cover_label: response.data.cover ? response.data.cover.split('/').pop() : "Upload Cover",
          logo_display: logoUrl || null,
          cover_display: coverUrl || null,
        });
      })
      .catch((error) => {
        console.error("Failed to load profile:", error.response?.data || error.message);
        this.setState({
          error: error.response?.data?.error || "Failed to load profile",
        });
      });
  }

  handleSubmit = async (e) => {
    e.preventDefault();
    removeError();
    this.setState({ error: null });

    const { auth } = this.context;
    if (!auth.token) {
      this.setState({ error: "Please log in to edit your profile." });
      return;
    }

    let formData = new FormData();
    formData.append("name", this.state.name);
    formData.append("email", this.state.email);
    formData.append("address", this.state.address);
    formData.append("description", this.state.description);
    if (document.getElementById("logo").files.length > 0) {
      formData.append("logo", document.getElementById("logo").files[0]);
    }
    if (document.getElementById("cover").files.length > 0) {
      formData.append("cover", document.getElementById("cover").files[0]);
    }

    try {
      const response = await this.makeRequestWithRefresh({
        method: "put",
        url: `${apiPath}/recruiter/profile/update/`,
        data: formData,
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });

      if (response.status === 200) {
        alert("Successfully edited profile");

        // تحديث بيانات المصادقة إذا لزم الأمر
        const { setAuthStatus } = this.context;
        setAuthStatus({
          email: response.data.email,
          entity: auth.entity,
          token: auth.token,
        });

        // تحديث logo و cover
        if (this.props.changeLogoAndCover && typeof this.props.changeLogoAndCover === 'function') {
          this.props.changeLogoAndCover(response.data.logo, response.data.cover);
        }

        const baseUrl = apiPath.endsWith("/api") ? apiPath.slice(0, -4) : apiPath;
        const logoUrl = response.data.logo && !response.data.logo.startsWith("http") ? `${baseUrl}${response.data.logo}` : response.data.logo;
        const coverUrl = response.data.cover && !response.data.cover.startsWith("http") ? `${baseUrl}${response.data.cover}` : response.data.cover;

        // إعادة تعيين labels وتحديث عرض الصور
        this.setState({
          logo_label: "Upload Logo",
          cover_label: "Upload Cover",
          logo: response.data.logo,
          cover: response.data.cover,
          logo_display: logoUrl,
          cover_display: coverUrl,
        });
      } else {
        this.setState({ error: "Request Failed" });
      }
    } catch (error) {
      console.error("Update failed:", error.response?.data || error.message);
      if (error.response && error.response.status === 422) {
        this.setState({ error: "Please correct highlighted errors" });
        printError(error.response.data);
      } else {
        this.setState({
          error: error.response?.data?.error || "Failed to update profile",
        });
      }
    }
  };

  changeLogoLabel = (e) => {
    if (e.target.files.length > 0) {
      this.setState({
        logo_label: e.target.files[0].name,
      });
    } else {
      this.setState({
        logo_label: "Upload Logo",
      });
    }
  };

  changeCoverLabel = (e) => {
    if (e.target.files.length > 0) {
      this.setState({
        cover_label: e.target.files[0].name,
      });
    } else {
      this.setState({
        cover_label: "Upload Cover",
      });
    }
  };

  onChange = (e) => {
    if (e.target.type === "file") {
      if (e.target.files.length > 0) {
        const file = e.target.files[0];
        const objectUrl = URL.createObjectURL(file);
        if (e.target.name === "logo") {
          this.setState({
            logo: file,
            logo_label: file.name,
            logo_display: objectUrl,
          });
        } else if (e.target.name === "cover") {
          this.setState({
            cover: file,
            cover_label: file.name,
            cover_display: objectUrl,
          });
        }
      } else {
        if (e.target.name === "logo") {
          this.setState({
            logo: "",
            logo_label: "Upload Logo",
            logo_display: null,
          });
        } else if (e.target.name === "cover") {
          this.setState({
            cover: "",
            cover_label: "Upload Cover",
            cover_display: null,
          });
        }
      }
    } else {
      this.setState({
        [e.target.name]: e.target.value,
      });
    }

    const errMsg = e.target.nextSibling || null;
    if (errMsg && errMsg.classList.contains("is-invalid")) {
      errMsg.remove();
    }
  };

  updateDescription = (value) => {
    this.setState({ description: value });
  };

  render() {
    return (
      <div className="job-applied-wrapper table-responsive-md" id="edit-company-profile">
        {this.state.error && (
          <div className="alert alert-danger">{this.state.error}</div>
        )}
        <form
          onSubmit={this.handleSubmit}
          encType="multipart/form-data"
          id="edit-company"
        >
          <div className="form-group my-30">
            <input
              type="text"
              placeholder="Company Name"
              className="form-control p-3"
              name="name"
              value={this.state.name || ""}
              onChange={this.onChange}
            />
          </div>

          <div className="form-group my-30">
            <input
              type="text"
              placeholder="Address"
              className="form-control p-3"
              name="address"
              value={this.state.address || ""}
              onChange={this.onChange}
            />
          </div>

          <div className="form-group my-30">
            <Editor
              placeholder="Write about your company ....."
              handleChange={this.updateDescription}
              editorHtml={this.state.description}
            />
          </div>

          <div className="form-group my-30">
            <div className="custom-file">
          <input
            type="file"
            className="custom-file-input"
            id="logo"
            name="logo"
            onChange={this.onChange}
          />
          <label className="custom-file-label" htmlFor="logo">
            {this.state.logo_label}
          </label>
          {this.state.logo_display && (
            <div className="mt-2" style={{ clear: "both", marginBottom: "1rem", overflow: "hidden" }}>
              <img src={this.state.logo_display} alt="Logo" style={{ maxWidth: "200px", maxHeight: "200px", width: "auto", height: "auto", objectFit: "contain" }} />
            </div>
          )}
            </div>
          </div>

          <div className="form-group my-30">
            <div className="custom-file">
          <input
            type="file"
            className="custom-file-input"
            id="cover"
            name="cover"
            onChange={this.onChange}
          />
          <label className="custom-file-label" htmlFor="cover">
            {this.state.cover_label}
          </label>
          {this.state.cover_display && (
            <div className="mt-2" style={{ clear: "both", marginBottom: "1rem", overflow: "hidden" }}>
              <img src={this.state.cover_display} alt="Cover" style={{ maxWidth: "400px", maxHeight: "200px", display: "block" }} />
            </div>
          )}
            </div>
          </div>

          <div className="form-submit mt-30 mb-3">
            <button type="submit" className="post-job-btn b-0 px-3 primary">
              Edit profile
            </button>
          </div>
        </form>
      </div>
    );
  }
}

export default EditEmployerProfile;