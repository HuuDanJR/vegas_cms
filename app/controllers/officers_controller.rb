require 'securerandom'

class OfficersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_officer, only: [:show, :edit, :update, :destroy]

  include CommonModule
  include RedisCacheModule
  include AttachmentModule

  # GET /officers
  # GET /officers.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @officers = Officer.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @officers = Officer.where("name LIKE ?", "%#{@search_query}%").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /officers/1
  # GET /officers/1.json
  def show
  end

  # GET /officers/new
  def new
    @officer = Officer.new
    @officerRef = Officer.where("language = ?", 1)
  end

  # GET /officers/1/edit
  def edit
  end

  # POST /officers
  # POST /officers.json
  def create
    result = true
    @officer = Officer.new(officer_params)
    if @officer.related_id.nil?
      @officer.related_id = 0
    end

    respond_to do |format|
      if @officer.save
        # Save attachment
        attachments = get_attachment_from_request(params[:officer][:attachment])
        attachments.each do |attachment|
          if attachment != nil
            ActiveRecord::Base::transaction do
              _ok = create_attachment_file(attachment)
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :new }
              format.json { render json: @officer.errors, status: :unprocessable_entity }
            end
          end
        end

        # Save officer_attachment
        attachments.each do |attachment|
          if attachment != nil
            officer_attachment = OfficerAttachment.new
            officer_attachment.officer_id = @officer.id
            officer_attachment.attachment_id = attachment.id
            ActiveRecord::Base::transaction do
              _ok = officer_attachment.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :new }
              format.json { render json: @officer.errors, status: :unprocessable_entity }
            end
          end
        end
        # Clear cache
        redis_cache_delete_by_prefix(Officer)

        format.html { redirect_to @officer, notice: t(:officer_create_success) }
        format.json { render :show, status: :created, location: @officer }
      else
        format.html { render :new }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /officers/1
  # PATCH/PUT /officers/1.json
  def update
    result = true

    respond_to do |format|
      if @officer.update(officer_update_params)
        # Save attachment
        attachments = get_attachment_from_request(params[:officer][:attachment])
        attachments.each do |attachment|
          if attachment != nil
            ActiveRecord::Base::transaction do
              _ok = create_attachment_file(attachment)
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :edit }
              format.json { render json: @officer.errors, status: :unprocessable_entity }
            end
          end
        end

        # Save officer_attachment
        attachments.each do |attachment|
          if attachment != nil
            officer_attachment = OfficerAttachment.new
            officer_attachment.officer_id = @officer_item.id
            officer_attachment.attachment_id = attachment.id
            ActiveRecord::Base::transaction do
              _ok = officer_attachment.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :edit }
              format.json { render json: @officer.errors, status: :unprocessable_entity }
            end
          end
        end

        # Clear cache
        redis_cache_delete_by_prefix(Officer)

        format.html { redirect_to @officer, notice: t(:officer_update_success) }
        format.json { render :show, status: :updated, location: @officer }
      else
        format.html { render :new }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /officers/1
  # DELETE /officers/1.json
  def destroy
    @officer.destroy
    respond_to do |format|
      format.html { redirect_to officers_url, notice: t(:officer_delete_success) }
      format.json { head :no_content }
    end
  end

  # EXPORT /officers/export
  def export
    officers = Officer.all
    send_file_list(officers)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_officer
    @officer = Officer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def officer_params
    params.require(:officer).permit(:name, :nickname, :date_of_birth, :home_town, :date_revolution, :date_of_sacrifice, :gender, :nationality, :ethnic, :religion, :head_of_household, :status,
    :position, :organization, :story, :note, :language, :related_id)
  end

  def officer_update_params
    params.require(:officer).permit(:name, :nickname, :date_of_birth, :home_town, :date_revolution, :date_of_sacrifice, :gender, :nationality, :ethnic, :religion, :head_of_household, :status,
                                    :position, :organization, :story, :note)
  end

  def send_file_list(officers)
    book = Axlsx::Package.new
    workbook = book.workbook
    sheet = workbook.add_worksheet name: "Report"

    styles = book.workbook.styles
    header_style = styles.add_style bg_color: "ffff00",
                                    fg_color: "00",
                                    b: true,
                                    alignment: {horizontal: :center},
                                    border: {style: :thin, color: 'F000000', :edges => [:left, :right, :top, :bottom]}
    border_style = styles.add_style :border => {:style => :thin, :color => 'F000000', :edges => [:left, :right, :top, :bottom]}

    sheet.add_row ["id",
                   "name",
                   "nickname",
                   "date_of_birth",
                   "home_town",
                   "date_revolution",
                   "date_of_sacrifice",
                   "gender",
                   "nationality",
                   "ethnic",
                   "religion",
                   "head_of_household",
                   "organization_vi",
                   "position_vi",
                   "story_vi",
                   "note_vi",
                   "organization_en",
                   "position_en",
                   "story_en",
                   "note_en",
                   "status",
                   "created_at",
                   "updated_at"], style: header_style

    officers.each do |item|
      language = {}
      item.officer_languages.each do |i|
        if i.language == true
          language['organization_vi'] = i.organization
          language['position_vi'] = i.position
          language['story_vi'] = i.story
          language['note_vi'] = i.note
        else
          language['organization_en'] = i.organization
          language['position_en'] = i.position
          language['story_en'] = i.story
          language['note_en'] = i.note
        end
      end
      sheet.add_row [item.id,
                     item.name,
                     item.nickname,
                     item.date_of_birth,
                     item.home_town,
                     item.date_revolution,
                     item.date_of_sacrifice,
                     item.gender,
                     item.nationality,
                     item.ethnic,
                     item.religion,
                     item.head_of_household,
                     language['organization_vi'],
                     language['position_vi'],
                     language['story_vi'],
                     language['note_vi'],
                     language['organization_en'],
                     language['position_en'],
                     language['story_en'],
                     language['note_en'],
                     item.status,
                     item.created_at,
                     item.updated_at]
    end

    folder_name = "officers"
    filename = "officers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename

    dir_path = File.dirname(tmp_file_path)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    book.serialize tmp_file_path
    send_file tmp_file_path, filename: filename
  end
end
