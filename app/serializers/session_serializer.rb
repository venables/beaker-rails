class SessionSerializer < ActiveModel::Serializer
  attributes :token, :user_id
end
