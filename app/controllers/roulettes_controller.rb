class RoulettesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_roulette, only: %i[ show edit update destroy ]

  include CommonModule
  include AttachmentModule

  # GET /roulettes or /roulettes.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @roulettes = Roulette.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @roulettes = Roulette.where("name LIKE ?", "%#{@search_query}%").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /roulettes/1 or /roulettes/1.json
  def show
  end

  # GET /roulettes/new
  def new
    @roulette = Roulette.new
  end

  # GET /roulettes/1/edit
  def edit
  end

  # POST /roulettes or /roulettes.json
  def create
    @roulette = Roulette.new(roulette_params)

    respond_to do |format|
      if @roulette.save
        format.html { redirect_to roulette_url(@roulette), notice: "Roulette was successfully created." }
        format.json { render :show, status: :created, location: @roulette }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @roulette.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roulettes/1 or /roulettes/1.json
  def update
    respond_to do |format|
      if @roulette.update(roulette_params)
        format.html { redirect_to roulette_url(@roulette), notice: "Roulette was successfully updated." }
        format.json { render :show, status: :ok, location: @roulette }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @roulette.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roulettes/1 or /roulettes/1.json
  def destroy
    @roulette.destroy

    respond_to do |format|
      format.html { redirect_to roulettes_url, notice: "Roulette was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # EXPORT /roulettes/export
  def export
    roulettes = Roulette.all
    send_file_list(roulettes)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roulette
      @roulette = Roulette.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def roulette_params
      params.require(:roulette).permit(:name, :description, :streaming_url, :publish)
    end

    def send_file_list(roulettes)
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
                     "description",
                     "streaming_url",
                     "publish",
                     "created_at",
                     "updated_at"], style: header_style
  
      roulettes.each do |item|
        sheet.add_row [item.id,
                       item.name,
                       item.description,
                       item.streaming_url,
                       item.publish,
                       item.created_at,
                       item.updated_at]
      end
  
      folder_name = "roulettes"
      filename = "roulettes_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
end
