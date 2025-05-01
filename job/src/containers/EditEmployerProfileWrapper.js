import React from "react";
import { useOutletContext } from "react-router-dom";
import EditEmployerProfile from "./EditEmployerProfile";

const EditEmployerProfileWrapper = (props) => {
  const { changeLogoAndCover } = useOutletContext();
  return <EditEmployerProfile {...props} changeLogoAndCover={changeLogoAndCover} />;
};

export default EditEmployerProfileWrapper;
