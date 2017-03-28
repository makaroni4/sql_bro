class QuerySearchSerializer < ActiveModel::Serializer
  attributes :description, :created_at, :show_path

  def show_path
    view_context.db_query_path(object)
  end
end
