class QueryResultSerializer < ActiveModel::Serializer
  attributes :id, :database, :body, :results_count, :fields, :result, :created_at, :description

  def created_at
    object.created_at.strftime("%d %b %Y %H:%M")
  end

  def fields
    JSON.parse(object.fields)
  end

  def result
    JSON.parse(object.result)
  end
end
