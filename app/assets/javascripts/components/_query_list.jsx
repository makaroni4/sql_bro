class QueryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queries: JSON.parse(this.props.queries)
    };
  }

  insertNewQuery(query) {
    this.setState({
      queries: [query].concat(this.state.queries)
    });
  }

  setupActionCable() {
    App.query = App.cable.subscriptions.create("QueryChannel", {
      run: function(db_connection_id, sql_body, description) {
        return this.perform("run_query", {
          db_connection_id: db_connection_id,
          sql_body: sql_body,
          description: description
        });
      },
      received: function(query) {
        query = JSON.parse(query);

        var $queryForm = $(".query-form");
        var $submitButton = $queryForm.find(".js-run-query");
        var $queryFormErrorContainer = $queryForm.find(".query-form__error");

        var $formContainer = $queryForm.parent(".query-form-container");
        var $formOverlay = $formContainer.find(".query-form__active-overlay")

        if(query.error) {
          $queryFormErrorContainer.text(query.error);
          $queryFormErrorContainer.show();
        } else {
          this.insertNewQuery(query);
          $queryFormErrorContainer.hide();
        }

        $formOverlay.removeClass("query-form__active-overlay--active");
        $submitButton.prop("disabled", false);
      }.bind(this)
    });
  }

  componentDidMount() {
    this.setupActionCable();
  }

  render() {
    let listItems = this.state.queries.map(function(query) {
      return <QueryListItem query={query} queryId={query.id} />;
    });

    return (
      <div>
        {listItems}
      </div>
    );
  }
}
