class Api::V1::AttachmentsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:download] # Requires access token for all actions
  before_action :set_object, only: [:download]

  include AttachmentModule

  def initialize()
    super(ATTACHMENT_ATTRIBUTE)
  end

  def download
    version = params[:version]

    if @object.file.present?
      if is_blank(version)
        send_file URI.decode(@object.file.url)
      else
        case version
        when "thumb"
          send_file URI.decode(@object.file.thumb.url)
        when "medium"
          send_file URI.decode(@object.file.medium.url)
        else
          send_file URI.decode(@object.file.url)
        end
      end
    else
      send_file URI.decode("#{Rails.root}/public" + @object.file.default_url), filename: @object.name, type: @object.file.content_type, disposition: 'Your file has been downloaded'
    end
  end

end