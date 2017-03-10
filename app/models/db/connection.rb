class Db::Connection < ApplicationRecord
  has_many :queries

  def connector
    "#{adapter}_connector".classify.constantize.new(id)
  end
end
