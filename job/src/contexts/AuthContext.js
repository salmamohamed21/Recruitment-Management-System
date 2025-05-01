

import React, { createContext, useState, useEffect } from "react";
import axios from "axios";
import { apiPath } from "../utils/Consts";

export const AuthContext = createContext();

const AuthProvider = ({ children }) => {
  const [auth, setAuth] = useState({
    email: "",
    entity: "guest",
    token: "",
    userId: null, // add userId to auth state
    profileImageUrl: "", // add profileImageUrl to auth state
    logoUrl: "", // add logoUrl to auth state
    coverUrl: "", // add coverUrl to auth state
    refreshToken: "", // أضف refreshToken
  });

  useEffect(() => {
    const storedEmail = localStorage.getItem("userEmail");
    const storedEntity = localStorage.getItem("userType");
    const storedToken = localStorage.getItem("accessToken");
    const storedRefreshToken = localStorage.getItem("refreshToken");
    const storedUserId = localStorage.getItem("userId");
    const storedProfileImageUrl = localStorage.getItem("profileImageUrl");
    const storedLogoUrl = localStorage.getItem("logoUrl");
    const storedCoverUrl = localStorage.getItem("coverUrl");

    if (storedEmail && storedEntity && storedToken && storedRefreshToken && storedUserId) {
      setAuth({
        email: storedEmail,
        entity: storedEntity,
        token: storedToken,
        refreshToken: storedRefreshToken,
        userId: storedUserId,
        profileImageUrl: storedProfileImageUrl || "",
        logoUrl: storedLogoUrl || "",
        coverUrl: storedCoverUrl || "",
      });
      console.log("Auth state restored from localStorage:", {
        email: storedEmail,
        entity: storedEntity,
        token: storedToken,
        refreshToken: storedRefreshToken,
        userId: storedUserId,
        profileImageUrl: storedProfileImageUrl || "",
        logoUrl: storedLogoUrl || "",
        coverUrl: storedCoverUrl || "",
      });
    } else {
      setAuth({
        email: "",
        entity: "guest",
        token: "",
        refreshToken: "",
        userId: null,
        profileImageUrl: "",
        logoUrl: "",
        coverUrl: "",
      });
      console.log("No auth data in localStorage, setting default state");
    }
  }, []);

  useEffect(() => {
    if (auth.email && auth.entity && auth.token && auth.refreshToken && auth.userId) {
      localStorage.setItem("userEmail", auth.email);
      localStorage.setItem("userType", auth.entity);
      localStorage.setItem("accessToken", auth.token);
      localStorage.setItem("refreshToken", auth.refreshToken);
      localStorage.setItem("userId", auth.userId);
      localStorage.setItem("profileImageUrl", auth.profileImageUrl || "");
      localStorage.setItem("logoUrl", auth.logoUrl || "");
      localStorage.setItem("coverUrl", auth.coverUrl || "");
    }
    console.log("Auth state updated:", auth);
  }, [auth]);

  const setAuthStatus = (userAuth) => {
    const newAuth = {
      email: userAuth.email || "",
      entity: userAuth.entity || "guest",
      token: userAuth.token || "",
      refreshToken: userAuth.refreshToken || "", // أضف refreshToken
      userId: userAuth.userId || null, // add userId to auth state
      profileImageUrl: userAuth.profileImageUrl || "", // add profileImageUrl to auth state
      logoUrl: userAuth.logoUrl || "", // add logoUrl to auth state
      coverUrl: userAuth.coverUrl || "", // add coverUrl to auth state
    };
    setAuth(newAuth);
  };

  const refreshToken = async () => {
    try {
      const response = await axios.post(`${apiPath}/token/refresh/`, {
        refresh: auth.refreshToken,
      });
      const newToken = response.data.access;
      setAuth((prev) => ({
        ...prev,
        token: newToken,
      }));
      return newToken;
    } catch (error) {
      console.error("Token refresh failed:", error);
      setUnauthStatus();
      window.location.href = "/login";
      return null;
    }
  };

  const setUnauthStatus = () => {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("userEmail");
    localStorage.removeItem("userType");
    localStorage.removeItem("refreshToken");

    setAuth({
      email: "",
      entity: "guest",
      token: "",
      refreshToken: "",
    });
    console.log("User logged out, auth state reset:", {
      email: "",
      entity: "guest",
      token: "",
      refreshToken: "",
    });
  };

  return (
    <AuthContext.Provider
      value={{ auth, setAuthStatus, setUnauthStatus, refreshToken }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;