class DbTableSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_view, :rows_count, :size, :schema_name

  def schema_name
    object.schema.name
  end
end
