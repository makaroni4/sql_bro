class Query extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queryId: this.props.queryId
    };
    this.DEFAULT_QUERY_DESCRIPTION = "<span class='query__description--default'>Description</span>";
  }

  componentDidMount() {
    var that = this;
    var queryId = that.state.queryId;
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
    if(!$queryDescription.text()) {
      $queryDescription.html(that.DEFAULT_QUERY_DESCRIPTION);
    }

    $queryDescription.on("focus", function() {
      $(this).find(".query__description--default").remove();
    });

    $queryDescription.on("blur", function() {
      var $this = $(this);

      $.ajax({
        method: "PATCH",
        dataType: "json",
        url: "/db/queries/" + queryId,
        data: {
          db_query: {
            description: $this.html()
          }
        }
      });

      if(!$this.text()) {
        $this.html(that.DEFAULT_QUERY_DESCRIPTION);
      }
    });
  }

  render() {
    let query = JSON.parse(this.props.query);
    let fields = this.props.fields;
    let results = this.props.results;

    console.log(query)

    let queryDescription = query.description ? query.description : this.DEFAULT_QUERY_DESCRIPTION;

    fields = fields.map(function(field) {
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
    results = results.map(function(values) {
      return <tr>{tableRow(values)}</tr>;
    });

    return (
      <div className="query" data-query-id={query.id}>
        <div className="query__description" contentEditable="true" dangerouslySetInnerHTML={{ __html: queryDescription }} >
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

        <div className="query__total-results">
          Total results: { query.results_count }
        </div>
      </div>
    );
  }
}
