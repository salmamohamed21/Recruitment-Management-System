import React, { Component } from "react";
import axios from "axios";
import ReactPaginate from "react-paginate";

export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      offset: 0,
      data: [],
      perPage: 10,
      currentPage: 0,
      query: "", // added query state
      postData: null,
      pageCount: 0,
    };
    this.handlePageClick = this.handlePageClick.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleSearchSubmit = this.handleSearchSubmit.bind(this);
  }

  receivedData() {
    const { offset, perPage, query } = this.state;
    if (!query.trim()) {
      this.setState({ postData: null, pageCount: 0 });
      return;
    }
    axios
      .post("http://127.0.0.1:8000/api/search/", { query: query })
      .then((res) => {
        const data = res.data.results || [];
        const slice = data.slice(offset, offset + perPage);
        const postData = slice.map((job) => (
          <React.Fragment key={job.id}>
            <h3>{job.title}</h3>
            <p>{job.description}</p>
            <p>Location: {job.location}</p>
            <p>Type: {job.type}</p>
            <p>Salary: {job.salary}</p>
            <hr />
          </React.Fragment>
        ));
        this.setState({
          pageCount: Math.ceil(data.length / perPage),
          postData,
        });
      })
      .catch((error) => {
        console.error("Search API error:", error);
        this.setState({ postData: <p>Error loading search results.</p> });
      });
  }

  handlePageClick(e) {
    const selectedPage = e.selected;
    const offset = selectedPage * this.state.perPage;
    this.setState(
      {
        currentPage: selectedPage,
        offset: offset,
      },
      () => {
        this.receivedData();
      }
    );
  }

  handleInputChange(e) {
    this.setState({ query: e.target.value });
  }

  handleSearchSubmit(e) {
    e.preventDefault();
    this.setState({ currentPage: 0, offset: 0 }, () => {
      this.receivedData();
    });
  }

  componentDidMount() {
    // Optionally, you can load initial data or leave empty
  }

  render() {
    return (
      <div>
        <form onSubmit={this.handleSearchSubmit}>
          <input
            type="text"
            placeholder="Search jobs..."
            value={this.state.query}
            onChange={this.handleInputChange}
          />
          <button type="submit">Search</button>
        </form>
        {this.state.postData}
        {this.state.pageCount > 1 && (
          <ReactPaginate
            previousLabel={"prev"}
            nextLabel={"next"}
            breakLabel={"..."}
            breakClassName={"break-me"}
            pageCount={this.state.pageCount}
            marginPagesDisplayed={2}
            pageRangeDisplayed={5}
            onPageChange={this.handlePageClick}
            containerClassName={"pagination"}
            subContainerClassName={"pages pagination"}
            activeClassName={"active"}
          />
        )}
      </div>
    );
  }
}
