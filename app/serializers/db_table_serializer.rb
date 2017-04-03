class DbTableSerializer < ActiveModel::Serializer
  attributes :name, :is_view, :rows_count, :size, :schema_name

  def schema_name
    object.schema.name
  end
end
