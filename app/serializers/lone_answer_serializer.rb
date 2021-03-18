class LoneAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_many :comments
  has_many :attachments
end
