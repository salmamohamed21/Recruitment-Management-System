import React, { useState, useContext, useEffect } from "react";
import { Link, matchPath, NavLink, useNavigate, useLocation } from "react-router-dom";
import { AuthContext } from "../contexts/AuthContext";
import Logo from "../images/logo.png";
import axios from "axios";
import { apiPath } from "../utils/Consts";

function Navbar() {
  //fetch auth user and handle logout
  const { auth, setUnauthStatus, refreshToken } = useContext(AuthContext);
  const [displayMenu, setDisplayMenu] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  const isAuthenticated = auth.email ? true : false;
  const entity = auth.entity;

  useEffect(() => {
    if (displayMenu) {
      setDisplayMenu(false);
    }
  }, [location]);

  const toggleDropdownMenu = () => {
    setDisplayMenu(!displayMenu);
  };

  const getIsAuthRouteStatus = (pathname) => {
    const matchEmployer = matchPath({ path: `/employer`, end: false }, pathname);
    const matchJobseeker = matchPath({ path: `/jobseeker`, end: false }, pathname);
    return matchEmployer || matchJobseeker ? true : false;
  };

  const { pathname } = location;
  const isAuthRoute = getIsAuthRouteStatus(pathname);

  const handleLogout = async (event) => {
    event.preventDefault();

    try {
      if (!auth.token) {
        console.error("No token available for logout");
        await setUnauthStatus();
        navigate("/login");
        return;
      }
      await axios.post(apiPath + "/logout_user/", null, {
        headers: {
          Authorization: `Bearer ${auth.token}`,
        },
      });
      await setUnauthStatus();
      navigate("/login");
    } catch (error) {
      if (error.response?.status === 401) {
        console.log("Access token expired, attempting to refresh...");
        const newToken = await refreshToken();
        if (newToken) {
          try {
            await axios.post(apiPath + "/logout_user/", null, {
              headers: {
                Authorization: `Bearer ${newToken}`,
              },
            });
            await setUnauthStatus();
            navigate("/login");
          } catch (retryError) {
            console.error("Retry logout failed:", retryError.response?.data || retryError.message);
            alert("Logout failed after token refresh. Please log in again.");
            await setUnauthStatus();
            navigate("/login");
          }
        } else {
          alert("Session expired. Please log in again.");
          await setUnauthStatus();
          navigate("/login");
        }
      } else {
        console.error("Logout failed:", error.response?.data || error.message);
        alert("Logout failed. Please try again.");
      }
    }
  };

  return (
    <section className="Navbar top-sticky">
      <div className="Container">
        <div className="row justify-content-between mx-0">
          <div className="col-6 col-lg-3">
            <div className="Navbar__logo-box">
              <Link to="/">
                <img src={Logo} alt="Logo" />
              </Link>
            </div>
          </div>
          <div className="col-6 col-lg-4">
            {/* desktop menu */}
            <div className="desktop-menu-wrapper d-none d-lg-block">
              {isAuthenticated ? (
                <div>
                  {isAuthRoute ? (
                    <div className="entity-panel text-right">
                      {/* // dropdown menu for employer and jobseeker (auth)
                      protected routes start */}
                      <div
                        className="menu-dropdown"
                        onClick={toggleDropdownMenu}
                      >
                        Hello,{" "}
                        <i style={{ fontSize: "18px", color: "#1771c4" }}>
                          {auth.email ? auth.email : "______"}
                        </i>
                      </div>
                      {displayMenu ? (
                        <ul>
                          <li>
                            <Link to={`/${entity}/change-password`}>
                              Change Password
                            </Link>
                          </li>
                          <li>
                            <a href="#x" onClick={handleLogout}>
                              Logout
                            </a>
                          </li>
                        </ul>
                      ) : null}
                      {/* // dropdown menu for employer and jobseeker (auth)
                      protected routes end */}
                    </div>
                  ) : (
                    <div className="default-menu">
                      {/* // inline menu for unprotected routes  start*/}
                      <ul>
                        <li>
                          <Link to={`/${entity}`}>
                            <i>My Account</i>
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/logout"
                            className="logout"
                            onClick={handleLogout}
                          >
                            Logout
                          </Link>
                        </li>
                      </ul>
                      {/* // inline menu for unprotected routes  end*/}
                    </div>
                  )}
                </div>
              ) : (
                <div className="default-menu">
                  <ul>
                    <li>
                      <NavLink to="/register"> Register</NavLink>
                    </li>
                    <li>
                      <NavLink to="/login"> Login</NavLink>
                    </li>
                  </ul>
                </div>
              )}
            </div>
            {/* desktop menu end*/}

            {/* mobile menu start*/}
            <div className="mobile-menu-wrapper text-right d-block d-lg-none ">
              <div className="mobile-menu">
                <div onClick={toggleDropdownMenu}>
                  <i className="fas fa-bars"></i>
                </div>
              </div>
              {displayMenu && (
                <div>
                  {isAuthenticated ? (
                    <div>
                      {isAuthRoute ? (
                        <div>
                          {/* // inline menu for unprotected routes  start*/}
                          <ul>
                            <li>
                              <Link to={`/${entity}/change-password`}>
                                Change Password
                              </Link>
                            </li>
                            <li>
                              <a href="#x" onClick={handleLogout}>
                                Logout
                              </a>
                            </li>
                          </ul>
                          {/* // inline menu for unprotected routes  end*/}
                        </div>
                      ) : (
                        <ul>
                          <li>
                            <Link to={`/${entity}`}> My Account</Link>
                          </li>
                          <li>
                            <Link to="/logout" onClick={handleLogout}>
                              Logout
                            </Link>
                          </li>
                        </ul>
                      )}
                    </div>
                  ) : (
                    <ul>
                      <li>
                        <Link to="/register"> Register</Link>
                      </li>
                      <li>
                        <Link to="/login"> Login</Link>
                      </li>
                    </ul>
                  )}
                </div>
              )}
            </div>
            {/* mobile menu end*/}
          </div>
        </div>
      </div>
    </section>
  );
}

export default Navbar;
