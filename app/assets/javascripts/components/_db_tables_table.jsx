class DbTablesTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      dbTables: [],
      dbConnectionId: this.props.dbConnectionId
    };
  }

  loadDbTables(url) {
    $.ajax({
      url: url,
      dataType: "json",
      success: function(data){
        this.setState({
          dbTables: data
        });
      }.bind(this)
    })
  }

  refreshDbTables() {
    // TODO: load spinner
    this.loadDbTables(Routes.db_connection_refresh_tables(this.state.dbConnectionId));
  }

  componentWillMount() {
    this.loadDbTables(Routes.db_connection_tables(this.state.dbConnectionId));
  }

  componentDidMount() {
    $("#js-db-tables").dataTable({
      dom: "<'db-tables-controls'<f><'js-tables-actions'>>" +
           "<'row'<'col-sm-12'tr>>",
      paginate: false
    });
  }

  componentWillUpdate() {
    $("#js-db-tables").dataTable().fnDestroy();
  }

  componentDidUpdate() {
    $("#js-db-tables").dataTable({
      dom: "<'db-tables-controls'<f><'js-tables-actions'>>" +
           "<'row'<'col-sm-12'tr>>",
      paginate: false,
      fnInitComplete: function() {
        var $refreshButton = $(".js-refresh-db-tables").clone();
        $refreshButton.appendTo($(".js-tables-actions"));
        $refreshButton.removeClass("hidden");
        var self = this;
        $refreshButton.on("click", function(e) {
          e.preventDefault();
          self.refreshDbTables();
        });
      }.bind(this)
    });
  }

  render() {
    let tableRow = function(dbTable) {
      return <tr key={dbTable.id}>
        <td>{ dbTable.schema_name }</td>
        <td>
          { dbTable.name }
          { dbTable.is_view &&
            <span className="label label-info">VIEW</span>
          }
        </td>
        <td>{ dbTable.rows_count }</td>
        <td>{ dbTable.size }</td>
      </tr>
    }

    let tableBody = this.state.dbTables.map(function(dbTable) {
      return tableRow(dbTable);
    });

    return (
      <div>
        <table id="js-db-tables" className="table table-striped table-hover">
          <thead>
            <tr>
              <th>Schema</th>
              <th>Name</th>
              <th>Records</th>
              <th>Size, Mb</th>
            </tr>
          </thead>

          <tbody>
            { tableBody }
          </tbody>
        </table>
      </div>
    );
  }
}
