class AttachmentsController < ApplicationController
  # skip_before_action :authenticate_user!
  before_action :set_attachment, only: [:download, :destroy]

  include AttachmentModule

  def download
    version = params[:version]
    if @attachment.file.present?
      if is_blank(version)
        send_file URI.decode(@attachment.file.url)
      else
        case version
        when "thumb"
          send_file URI.decode(@attachment.file.thumb.url)
        when "medium"
          send_file URI.decode(@attachment.file.medium.url)
        else
          send_file URI.decode(@attachment.file.url)
        end
      end
    else
      send_file URI.decode("#{Rails.root}/public" + @attachment.file.default_url), filename: @attachment.name, type: @attachment.file.content_type, disposition: 'Your file has been downloaded'
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
