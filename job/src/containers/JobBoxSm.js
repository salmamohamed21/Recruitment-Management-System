import * as React from "react";
import { useContext } from "react";
import { useNavigate } from "react-router-dom";
import CompnayLogo from "../images/company-logo.png";
import { AuthContext } from "../contexts/AuthContext";
import { apiPath } from "../utils/Consts";

export default ({ job, classValue }) => {
  const { auth } = useContext(AuthContext);
  const navigate = useNavigate();

  if (!job) {
    return null;
  }

  const baseUrl = apiPath && apiPath.endsWith("/api") ? apiPath.slice(0, -4) : apiPath;

  const authLogoUrl = auth.logoUrl && !auth.logoUrl.startsWith("http") ? `${baseUrl}${auth.logoUrl}` : auth.logoUrl;
  const jobLogoUrl = job.recruiter?.logo && !job.recruiter.logo.startsWith("http") ? `${baseUrl}${job.recruiter.logo}` : job.recruiter?.logo;

 // const logoUrl = authLogoUrl || jobLogoUrl;

  const handleClick = (e) => {
    e.preventDefault();
    if (!auth.token) {
      alert("You must log in first");
    } else {
      navigate(`/job/${job.id}`);
    }
  };

  return (
    <div className={classValue}>
      <div className="job-box d-flex align-items-center">
        <img
          src={jobLogoUrl ? jobLogoUrl : CompnayLogo}
          alt="Company Logo"
          className="job-logo"
        />
        <div className="job-info ">
          <ul>
            <li>
              <strong> {job.employer?.name}</strong>
            </li>
            <li>
              <a href={`/job/${job.id}`} className="job-title" onClick={handleClick}>
                {job.title}
              </a>
            </li>
            <li>
              <small>Deadline: {job.expiry_date} </small>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
};
