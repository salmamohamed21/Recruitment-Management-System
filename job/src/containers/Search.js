import * as React from "react";
import axios from "axios";
import BannerSearch from "./BannerSearch";
import { apiPath } from "../utils/Consts";
import Loader from "./Loader";
import queryString from "query-string";
import ReactPaginate from "react-paginate";
import Filter from "./Filter";
import JobBoxSm from "./JobBoxSm";
import { useLocation, useNavigate } from "react-router-dom";

const Search = () => {
  const [jobs, setJobs] = React.useState([]);
  const [isLoading, setIsLoading] = React.useState(true);
  const [jobs_count, setJobsCount] = React.useState(0);
  const [keyword, setKeyword] = React.useState("");

  //for pagination
  const [pageCount, setPageCount] = React.useState(0);
  const [currentPage, setCurrentPage] = React.useState(1);

  const location = useLocation();
  const navigate = useNavigate();

  //search based on url query params
  React.useEffect(() => {
    const values = queryString.parse(location.search);
    let keyword = values.keyword || "";
    setKeyword(keyword);

    ajaxFetchJobs({ query: keyword, page: 1 });
  }, [location.search]);

  //fetch jobs via ajax
  const ajaxFetchJobs = async (data) => {
    setIsLoading(true);
    try {
      const response = await axios.post(`${apiPath}/search/`, data);
      const results = response.data.results || [];
      // Defensive check for employer object
      const jobsWithDefaults = results.map(job => ({
        ...job,
        employer: job.recruiter || { name: "Unknown", address: "Unknown" },
        slug: job.slug || "",
        title: job.title || "No Title",
        salary: job.salary || "N/A",
        deadline: job.deadline || "N/A"
      }));
      setJobs(jobsWithDefaults);
      setJobsCount(jobsWithDefaults.length);
      setPageCount(1); // Backend pagination not implemented, set to 1 or adjust if backend supports
      setIsLoading(false);
    } catch (error) {
      console.log(error);
      setIsLoading(false);
    }
  };

  //trace keyword value
  const onChangeKeyword = (e) => {
    setKeyword(e.target.value);
  };

  //reset form handler
  const resetFilter = (e) => {
    e.preventDefault();
    document.getElementById("searchPageForm").reset();
    filterJobs();
  };

  //search based on filter form params & search keyword val
  const filterJobs = () => {
    ajaxFetchJobs({ query: keyword, page: 1 });
  };

  //pagination events & function
  const handlePageClick = (data) => {
    const selectedPage = data.selected + 1;
    setCurrentPage(selectedPage);
    getCurrentPageJobs(selectedPage);
  };

  //handle current page change event of pagination
  const getCurrentPageJobs = async (pageNo) => {
    ajaxFetchJobs({ query: keyword, page: pageNo });
    document
      .getElementById("job-count")
      .scrollIntoView({ behavior: "smooth", block: "center" });
  };

  return (
    <div className="search-page">
      <BannerSearch
        keyword={keyword}
        onChangeKeyword={onChangeKeyword}
        onBannerFormSubmit={filterJobs}
      />
      <div className="Container">
        <form action="" id="searchPageForm">
          <div className="row my-5 mx-0">
            <div className="col-lg-4">
              <Filter filterJobs={filterJobs} />
            </div>
            <div className="col-lg-8">
              <div className="search-results">
                {isLoading && <Loader />}

                {!isLoading && (
                  <div className="col-12 offset-lg-1 col-lg-11 px-0">
                    <div className="results-count-reset-wrapper mt-lg-0 mt-3 mb-5">
                      <div className="card">
                        <div className="card-body row p-3">
                          <div className="col-6">
                            <h3 className="h6" id="job-count">
                              {jobs_count} jobs found
                            </h3>
                          </div>
                          <div className="col-6 text-right reset-filter">
                            <a
                              href="#v"
                              className="text-secondary"
                              onClick={resetFilter}
                            >
                              <span className="icon-reset mr-1"></span>
                              Reset Filter
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>

                    {jobs_count > 0 && (
                      <div>
                    {jobs.map((job, index) => {
                      return <JobBoxSm key={index} job={job} classValue="mb-3" />;
                    })}

                        <ReactPaginate
                          previousLabel={"<<"}
                          nextLabel={">>"}
                          breakLabel={"..."}
                          breakClassName={"break-me"}
                          pageCount={pageCount}
                          marginPagesDisplayed={2}
                          pageRangeDisplayed={5}
                          onPageChange={handlePageClick}
                          containerClassName={"pagination"}
                          activeClassName={"active"}
                        />
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Search;
