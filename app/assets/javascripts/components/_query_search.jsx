function escapeRegexCharacters(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

class QuerySearch extends React.Component {
  constructor() {
    super();

    this.state = {
      value: '',
      suggestions: [],
      isLoading: false
    };

    this.lastRequestId = null;
  }



  getSuggestionValue(suggestion) {
    return suggestion.description;
  }

  loadSuggestions(value) {
    // Cancel the previous request
    if (this.lastRequestId !== null) {
      clearTimeout(this.lastRequestId);
    }

    this.setState({
      isLoading: true
    });

    // Fake request
    var that = this;
    this.lastRequestId = setTimeout(function() {
      var escapedValue = escapeRegexCharacters(value.trim());

      if (escapedValue === '') {
        return [];
      }

      var queries = $.ajax({
        url: "/db/queries/search",
        method: "GET",
        dataType: "json",
        data: {
          q: escapedValue
        },
        success: function(queires) {
          that.setState({
            isLoading: false,
            suggestions: queries.responseJSON
          });
        }
      });
    }, 1000);
  }

  onChange(event, params) {
    this.setState({
      value: params.newValue
    });
  };

  onSuggestionSelected(event, params) {
    event.preventDefault();

    window.location.replace(params.suggestion.show_path);
  }

  onSuggestionsFetchRequested(params) {
    this.loadSuggestions(params.value);
  };

  onSuggestionsClearRequested() {
    this.setState({
      suggestions: []
    });
  };

  renderSuggestion(suggestion) {
    return (
      <div className="query-autosuggest-item">
        <div className="query-autosuggest-item__description">
          {suggestion.description}
        </div>

        <div className="query-autosuggest-item__date">
          {suggestion.created_at}
        </div>
      </div>
    );
  }

  render() {
    let inputProps = {
      placeholder: "Search queries",
      value: this.state.value,
      onChange: this.onChange.bind(this)
    };
    let status = (this.state.isLoading ? 'Loading...' : 'Type to load suggestions');

    return (
      <div>
        <Autosuggest
          suggestions={this.state.suggestions}
          onSuggestionsFetchRequested={this.onSuggestionsFetchRequested.bind(this)}
          onSuggestionsClearRequested={this.onSuggestionsClearRequested.bind(this)}
          getSuggestionValue={this.getSuggestionValue}
          renderSuggestion={this.renderSuggestion.bind(this)}
          onSuggestionSelected={this.onSuggestionSelected.bind(this)}
          inputProps={inputProps} />
      </div>
    );
  }
}
