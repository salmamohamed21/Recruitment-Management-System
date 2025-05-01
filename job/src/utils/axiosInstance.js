import axios from "axios";

const apiPath = "http://127.0.0.1:8000"; // explicitly set to 127.0.0.1 for testing

// Create axios instance
const axiosInstance = axios.create({
  baseURL: apiPath,
  timeout: 30000000,
});

// Add a request interceptor to include token in headers
axiosInstance.interceptors.request.use(
  (config) => {
    // Get token from localStorage
    const token = localStorage.getItem("accessToken") || localStorage.getItem("token");
    console.log("Axios interceptor token:", token);
    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
      console.log("Axios interceptor headers:", config.headers);
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default axiosInstance;
