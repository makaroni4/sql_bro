class DbTablesTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      dbTables: [],
      dbConnectionId: this.props.dbConnectionId
    };
  }

  loadData() {
    $.ajax({
      url: Routes.db_connection_tables(this.state.dbConnectionId),
      dataType: "json",
      success: function(data){
        this.setState({
          dbTables: data
        });
      }.bind(this)
    })
  }

  componentWillMount() {
    this.loadData();
  }

  componentDidMount() {
    $("#js-db-tables").dataTable({
      dom: "<'db-tables-controls'<f><'js-tables-actions'>>" +
           "<'row'<'col-sm-12'tr>>"
    });
  }

  componentWillUpdate() {
    $("#js-db-tables").dataTable().fnDestroy();
  }

  componentDidUpdate() {
    $("#js-db-tables").dataTable({
      dom: "<'db-tables-controls'<f><'js-tables-actions'>>" +
           "<'row'<'col-sm-12'tr>>"
    });
  }

  render() {
    let tableRow = function(dbTable) {
      return <tr>
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
    );
  }
}
