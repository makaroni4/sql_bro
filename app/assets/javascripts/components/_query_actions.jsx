class QueryActions extends React.Component {
  render() {
    return (
      <div className="query-actions">
        <a href={Routes.query_path(this.props.queryId, "csv")} className="btn btn-default btn-sm">
          <i className="fa fa-download"></i>
          CSV
        </a>
      </div>
    )
  }
}
