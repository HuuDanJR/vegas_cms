class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  has_many :place_attachments, dependent: :destroy
  has_many :plant_attachments, dependent: :destroy
  has_many :river_attachments, dependent: :destroy
  has_many :street_attachments, dependent: :destroy
  has_many :zone_attachments, dependent: :destroy
end
