import * as React from "react";
import {
  BrowserRouter as Router,
  Route,
  Routes,
  Navigate,
} from "react-router-dom";
import Register from "./Register";
import Login from "./Login";
import Home from "./Home";
import EmployerWithRouter from "./Employer"; // تأكد من استيراد EmployerWithRouter
import PrivateRoute from "../hoc/PrivateRoute";
import { AuthContext } from "../contexts/AuthContext.js";
import axios from "axios";
import JobseekerWithRouter from "./Jobseeker"; // تأكد من استيراد JobseekerWithRouter
import ViewAppliedJobs from "./ViewAppliedJobs"; // Added import for ViewAppliedJobs
import Search from "./Search";
import JobPage from "./JobPage";
import Navbar from "./Navbar";
import NotFound from "../components/NotFound";
import EditEmployerProfile from "./EditEmployerProfile";
import EditEmployerProfileWrapper from "./EditEmployerProfileWrapper";
import EditJobseekerProfile from "./EditJobseekerProfile";
import PostNewJob from "./PostNewJob"; // إضافة الاستيراد
import ViewPostedJobs from "./ViewPostedJobs"; // إضافة الاستيراد
import ViewJobApplicant from "./ViewJobApplicants"; // إضافة الاستيراد
import ChangePassword from "./ChangePassword"; // إضافة الاستيراد
import AtsResult from "./AtsResult.js";
import JobSuggestions from "./JobSuggestions";
import CreateCVPage from "./CreateCVPage"; 
import ForgotPassword from "./ForgotPassword";
//import ViewSuggestions from "./ViewSuggestions";
import PreferencesQuestionnaire from "./PreferencesQuestionnaire";
import ViewJobSeekerDetails from "./ViewJobSeekerDetails";
function RootContainer() {
  const { auth } = React.useContext(AuthContext);
  const AUTH_TOKEN = auth.token || null;
  axios.defaults.headers.common["Authorization"] = AUTH_TOKEN;

  return (
    <Router>
      <div className="global-container">
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/search" element={<Search />} />
          <Route path="/job" element={<Navigate to="/search" />} />
          <Route path="/job/:jobId" element={<JobPage />} />
          <Route path="/home" element={<Navigate to="/" />} />
          <Route element={<PrivateRoute type="guest" />}>
            <Route path="/register" element={<Register />} />
            <Route path="/login" element={<Login />} />
            <Route path="/forgot-password" element={<ForgotPassword />} />
          </Route>
            <Route element={<PrivateRoute type="employer" />}>
              <Route path="/employer" element={<EmployerWithRouter />}>
                {/* Nested routes with props passing */}
                <Route
                  path="editemployerprofile"
                  element={<EditEmployerProfileWrapper />}
                />
                <Route path="postnewjob" element={<PostNewJob />} />
                <Route path="jobsuggestions" element={<JobSuggestions />} />
                <Route path="viewpostedjobs" element={<ViewPostedJobs />} />
                
                <Route path="viewjobapplicants/:jobId" element={<ViewJobApplicant />} />
                <Route path="change-password" element={<ChangePassword />} />
                <Route path="viewjobseekerdetails/:id" element={<ViewJobSeekerDetails />} />
              </Route>
            </Route>
          <Route element={<PrivateRoute type="jobseeker" />}>
            <Route path="/jobseeker" element={<JobseekerWithRouter />}>
              <Route index element={<ViewAppliedJobs />} />
              <Route path="editjobseekerprofile" element={<EditJobseekerProfile />} />
              <Route path="change-password" element={<ChangePassword />} />
              <Route path="AtsResult" element={<AtsResult />} />
              <Route path="preferences" element={<PreferencesQuestionnaire />} />
              {/* Removed notifications route */}
              {/* Removed nested :id route */}
            </Route>
            <Route path="create-cv" element={<CreateCVPage />} />
            {/* New standalone route for jobseeker profile */}
            <Route path="/jobseeker-profile/:id" element={<React.Suspense fallback={<div>Loading...</div>}><ViewJobSeekerDetails /></React.Suspense>} />
          </Route>
          <Route path="*" element={<NotFound />} />
        </Routes>
      </div>
    </Router>
  );
}

export default RootContainer;
