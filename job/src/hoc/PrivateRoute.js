import React, { useContext } from "react";
import { Navigate, Outlet } from "react-router-dom";
import { AuthContext } from "../contexts/AuthContext";

const PrivateRoute = ({ type }) => {
  const { auth } = useContext(AuthContext);
  const { entity } = auth;

  switch (type) {
    case "guest":
      if (entity !== "guest") {
        return <Navigate to={`/${entity}`} />;
      }
      break;
    case "employer":
      if (entity !== "employer") {
        return <Navigate to="/login" />;
      }
      break;
    case "jobseeker":
      if (entity !== "jobseeker") {
        return <Navigate to="/login" />;
      }
      break;
    default:
      break;
  }

  return <Outlet />;
};

export default PrivateRoute;
