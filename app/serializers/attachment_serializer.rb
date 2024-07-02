class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :user

  def user
    UserSerializer.new(User.find(object.user_id))
  end
end
