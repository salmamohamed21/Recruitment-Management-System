import * as React from "react";
import { apiPath } from "../utils/Consts";
import HotJobs from "./HotJobs";
import Banner from "./Banner";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const Home = () => {
  const [jobs, setJobs] = React.useState([]);
  const [loading, setLoading] = React.useState(true);
  const [keyword, setKeyword] = React.useState("");
  const navigate = useNavigate();

  const onChangeKeyword = (e) => {
    setKeyword(e.target.value);
  };
  
  const onBannerFormSubmit = () => {
    console.log("fas");
    navigate('/search?keyword=' + keyword);
  };

  React.useEffect(() => {
    axios
      .get("http://localhost:8000/api/public/hot-jobs/")
      .then((response) => {
        if (response.data.resp === 1) {
          console.log(response);
          setJobs(response.data.hot_jobs);
          setLoading(false);
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  return (
    <div className="home">
      <Banner
        keyword={keyword}
        onChangeKeyword={onChangeKeyword}
        onBannerFormSubmit={onBannerFormSubmit}
      />

      {!loading ? (
        <HotJobs jobs={jobs} />
      ) : (
        <div className="text-center mt-5">
          <div className="spinner-grow" role="status">
            <span className="sr-only">Loading...</span>
          </div>
          <h6 className="mt-1">Loading... </h6>
        </div>
      )}
    </div>
  );
};

export default Home;
