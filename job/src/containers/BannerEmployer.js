import React, { useEffect, useContext } from 'react';
import CompanyCover from "../images/cover.jpg";
import CompanyLogo from "../images/company-logo.png";
import { apiPath } from "../utils/Consts";
import { AuthContext } from "../contexts/AuthContext";

const BannerEmployer = () => {
  const { auth } = useContext(AuthContext);

  useEffect(() => {
    console.log('Cover image URL from auth:', auth.coverUrl);
    console.log('Logo image URL from auth:', auth.logoUrl);
  }, [auth.coverUrl, auth.logoUrl]);

  const baseUrl = apiPath && apiPath.endsWith("/api") ? apiPath.slice(0, -4) : apiPath;

  const coverUrl = auth.coverUrl && !auth.coverUrl.startsWith("http") ? `${baseUrl}${auth.coverUrl}` : auth.coverUrl;
  const logoUrl = auth.logoUrl && !auth.logoUrl.startsWith("http") ? `${baseUrl}${auth.logoUrl}` : auth.logoUrl;

  return (
    <section
      className="company-cover"
      style={{
        backgroundImage: `url(${coverUrl ? coverUrl : CompanyCover})`,
      }}
    >
      <div className="company-logo-wrap">
        <img
          src={logoUrl ? logoUrl : CompanyLogo}
          alt="company logo"
        />
      </div>
    </section>
  );
};

export default BannerEmployer;
