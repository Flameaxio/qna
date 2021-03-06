class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, touch: true

  mount_uploader :file, FileUploader

  def name
    file.path.split('/').last
  end
end
