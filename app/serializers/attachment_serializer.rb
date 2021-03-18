class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file

  def file
    "http//#{Rails.application.config.host}/#{object.file.url}"
  end
end
