import React from 'react';
import PropTypes from 'prop-types';

const SuggestionsList = ({ suggestions }) => {
  return (
    <div className="suggestions-list">
      {suggestions.length > 0 ? (
        <ul className="list-group">
          {suggestions.map((suggestion, index) => (
            <li key={index} className="list-group-item">
              <h5>{suggestion.title}</h5>
              <p>{suggestion.company}</p>
              <p>{suggestion.location}</p>
              <p>{suggestion.description}</p>
            </li>
          ))}
        </ul>
      ) : (
        <p>No suggestions found</p>
      )}
    </div>
  );
};

SuggestionsList.propTypes = {
  suggestions: PropTypes.array.isRequired
};

export default SuggestionsList;
