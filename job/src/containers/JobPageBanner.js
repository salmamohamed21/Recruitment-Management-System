import React from "react";
import DefaultCover from "../images/cover.jpg";
import DefaultLogo from "../images/company-logo.png";

const JobPageBanner = ({ cover, logo }) => {
  const coverUrl = cover && cover.length > 0 ? cover : DefaultCover;
  const logoUrl = logo && logo.length > 0 ? logo : DefaultLogo;

  return (
    <section
      className="company-cover"
      style={{
        backgroundImage: `url(${coverUrl})`,
      }}
    >
      <div className="company-logo-wrap">
        <img src={logoUrl} alt="company logo" />
      </div>
    </section>
  );
};

export default JobPageBanner;
