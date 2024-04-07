class UserSerializer < ActiveModel::Serializer
  attributes :ci_number, :full_name, :email, :username
  belongs_to :office, serializer: OfficeSerializer
end
