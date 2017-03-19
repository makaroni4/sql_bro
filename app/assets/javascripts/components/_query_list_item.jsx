class QueryListItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queryId: this.props.queryId
    };
  }

  componentDidMount() {
    var queryId = this.state.queryId;
    var $queryBlock = $(".query[data-query-id=" + queryId + "]");
    let $queryCode = $queryBlock.find("code").each(function(i, block) {
      hljs.highlightBlock(block);
    });

    var $queryResultTable = $queryBlock.find("table");
    $queryResultTable.dragtable();
    $queryResultTable.find("th,tr,td").resizable({
      handles: "n, s",
      create: function(e, ui) {
        $(".ui-resizable-n,.ui-resizable-s").css("cursor", "row-resize");
      }
    });
    $queryResultTable.colResizable({
      resizeMode: "overflow"
    });

    var $queryDescription = $queryBlock.find(".query__description");
    $queryDescription.on("blur", function() {
      $.ajax({
        method: "PATCH",
        url: "/db/queries/" + queryId,
        data: {
          db_query: {
            description: $(this).html()
          }
        }
      });
    });
  }

  render() {
    let query = this.props.query;
    let fields = query.fields.map(function(field) {
      return <th>{field}</th>;
    });
    let tableRow = function(values) {
      return values.map(function(value) {
        if(Object.prototype.toString.call(value) === '[object Array]') {
          return <td>{value.join(", ")}</td>;
        } else {
          return <td>{value}</td>;
        }
      });
    };

    let totalResults = query.results.length;

    let results = query.results.slice(0, 10).map(function(values) {
      return <tr>{tableRow(values)}</tr>;
    });

    return (
      <div className="query" data-query-id={query.id}>
        <div className="query__description" contentEditable="true" dangerouslySetInnerHTML={{__html: query.description}} >
        </div>

        <time className="query__time">
          { query.created_at }
        </time>

        <div className="query__sql-body">
          <div className="query__db label label-default">
            <i className="fa fa-database"></i>
            { query.database }
          </div>

          <pre>
            <code>
              { query.body }
            </code>
          </pre>
        </div>

        <div className="query__results">
          <table>
            <thead>
              <tr>
                { fields }
              </tr>
            </thead>
            <tbody>
              { results }
            </tbody>
          </table>
        </div>

        { totalResults > 10 &&
          <div className="query__total-results">
            Total results: { query.results.length }
          </div>
        }
      </div>
    );
  }
}
