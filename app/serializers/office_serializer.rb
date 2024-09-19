class OfficeSerializer < ActiveModel::Serializer
  attributes :id, :name, :renamed, :active
end
