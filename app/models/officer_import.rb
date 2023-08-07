require 'digest'
require 'securerandom'

class OfficerImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  include AttachmentModule

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then
      Csv.new(file.path, nil, :ignore)
    when ".xls" then
      Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then
      Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_items
    spreadsheet = open_spreadsheet

    @officerList = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      @officerList.push(OfficerData.new(row["name"], row["nickname"], row["date_of_birth"], row["home_town"],
                                        row["date_revolution"], row["date_of_sacrifice"], row["gender"], row["nationality"],
                                        row["ethnic"], row["religion"], row["head_of_household"], row["organization"],
                                        row["position"], row["story"], row["note"], row["language"], row["related_id"], row["status"], row["image"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items

    @officerList.each do |item|

      officer = Officer.new
      officer.name = item.name
      officer.nickname = item.nickname.nil? ? "" : item.nickname
      officer.date_of_birth = item.date_of_birth.nil? ? nil : Date::strptime(item.date_of_birth, "%m/%d/%Y")
      officer.home_town = item.home_town.nil? ? "" : item.home_town
      officer.date_revolution = item.date_revolution.nil? ? nil : Date::strptime(item.date_revolution, "%m/%d/%Y")
      officer.date_of_sacrifice = item.date_of_sacrifice.nil? ? nil : Date::strptime(item.date_of_sacrifice, "%m/%d/%Y")
      officer.gender = item.gender
      officer.nationality = item.nationality.nil? ? "" : item.nationality
      officer.ethnic = item.ethnic.nil? ? "" : item.ethnic
      officer.religion = item.religion.nil? ? "" : item.religion
      officer.head_of_household = item.head_of_household.nil? ? "" : item.head_of_household
      officer.status = item.status
      officer.language = item.language
      officer.organization = item.organization
      officer.position = item.position
      officer.story = item.story
      officer.note = item.note
      officer.related_id = item.related_id

      # Save attachment
      if !item.image.nil?
        attachments = item.image.split(',').map(&:strip)
        attachments_saved = []
        attachments.each do |item|
          attachment = save_image(item)
          if attachment != nil
            ActiveRecord::Base::transaction do
              _ok = create_attachment_file(attachment)
              raise ActiveRecord::Rollback, result = false unless _ok
              attachments_saved.push(attachment)
            end
            if result == false
              return false
            end
          end
        end
      end

      ActiveRecord::Base::transaction do
        _ok = officer.save
        raise ActiveRecord::Rollback, result = false unless _ok

        # Save officer_attachment
        if !item.image.nil?
          attachments_saved.each do |item|
            officer_attachment = OfficerAttachment.new
            officer_attachment.officer_id = officer.id
            officer_attachment.attachment_id = item.id
            ActiveRecord::Base::transaction do
              _ok = officer_attachment.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              return false
            end
          end
        end
      end

      if result == false
        return false
      end
    end

    return true
  end

  def save_image(file_name)
    if file_name.nil?
      return nil
    end
    attachment = Attachment.new
    begin
      attachment.file = Pathname.new(Rails.root.join("db/import/images/#{file_name}")).open
    rescue Exception => e
      return nil
    end
    attachment.category = get_extension_file_upload(attachment.file)
    attachment.name = file_name
    attachment.file_hash = Digest::MD5.hexdigest(attachment.file.read)
    return attachment
  end
end

class OfficerData
  attr_accessor :name, :nickname, :date_of_birth, :home_town, :date_revolution, :date_of_sacrifice, :gender, :nationality,
                :ethnic, :religion, :head_of_household, :organization, :position, :story, :note,
                :language, :related_id, :status, :image

  def initialize(name, nickname, date_of_birth, home_town, date_revolution, date_of_sacrifice, gender, nationality, ethnic,
                 religion, head_of_household, organization, position, story, note, language, related_id, status, image)
    @name = name
    @nickname = nickname
    @date_of_birth = date_of_birth
    @home_town = home_town
    @date_revolution = date_revolution
    @date_of_sacrifice = date_of_sacrifice
    @gender = gender
    @nationality = nationality
    @ethnic = ethnic
    @religion = religion
    @head_of_household = head_of_household
    @organization = organization
    @position = position
    @story = story
    @note = note
    @language = language
    @related_id = related_id
    @status = status
    @image = image
  end
end