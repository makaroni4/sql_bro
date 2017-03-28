class QuerySearchSerializer < ActiveModel::Serializer
  attributes :description, :created_at, :show_path

  def created_at
    object.created_at.strftime("%d %b %Y %H:%M")
  end

  def show_path
    view_context.db_query_path(object)
  end
end
