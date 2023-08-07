module CommonModule

  PHOTO_EXTENSION = ["jpeg", "jpg", "gif", "tif", "png", "svg", "webp"]
  CATEGORY_ATTACHMENT = {picture: 1, document: 2}
  PATH_STORE_ATTACHMENT = ENV['ATTACHMENT_REPOSITORY']
  PASSWORD_DEFAULT = "Vcms@2022"
  def is_disable_total(clazz)
    clazz_str = clazz.to_s
    DISABLE_GET_TOTAL_CLASS.each do |class_disable|
      if clazz_str == class_disable
        return true
      end
    end
    return false
  end

  PAGING_CONFIG = {
      LIMIT: ENV['PAGING_LIMIT_WEB'].to_i,
      OFFSET: 0
  }

  PAGING_CONFIG_API = {
      LIMIT: ENV['PAGING_LIMIT_API'].to_i,
      OFFSET: 0
  }

  PAGING_OFFICER_CONFIG = {
      LIMIT: ENV['PAGING_LIMIT_WEB'].to_i,
      OFFSET: 0
  }

  OBJECT_STATUS = {
      ACTIVE: 1,
      INACTIVE: 0,
      DELETE: -1
  }

  # Return a default result
  def default_result
    return JSON.parse({message: "", data: "", status: 200, result: true}.to_json)
  end

  # Render message json
  def message_json(value)
    return {message: value}
  end

  # Convert boolean strings as "true", "false", "0", "1" to boolean value
  def convert_string_to_boolean(string)
    if (string == false || string == "false" || string == "0")
      result = false
    elsif (string == true || string == "true" || string == "1")
      result = true
    else
      result = nil
    end

    return result
  end

  # Validate blank
  def is_blank(value)
    return value.blank?
  end

  # Validate number
  def is_number(value)
    if is_blank(value)
      return false
    end
    return (value.to_s =~ NUMBER_PATTERN)
  end

  def is_number_in_range(value, from_number, to_number)
    if !is_number(value) || !is_number(from_number) || !is_number(to_number)
      return false
    end
    if (value < from_number || value > to_number)
      return false
    end
    return true
  end

  # Validate boolean value string
  def is_boolean_string(value)
    result = true
    if (value.nil?)
      result = false
    elsif (value == false || value == true || value == 'false' || value == 'true' || value == '0' || value == '1')
      result = true
    else
      result = false
    end
    return result
  end

  # Check that value is a datetime with timezone
  def is_datetime(value)
    if is_blank(value)
      result = false
    elsif !(value.to_s =~ DATETIME_PATTERN)
      result = false
    else
      result = true
    end
    return result
  end

  def get_extension_file_upload(file)
    extension = file.content_type.split('/')[1]
    if (PHOTO_EXTENSION.include? (extension.downcase))
      category = CATEGORY_ATTACHMENT[:picture]
    else
      category = CATEGORY_ATTACHMENT[:document]
    end
    return category
  end

  def get_delivery_options(_address, _port, _domain, _user_name, _password, _authentication, _enable_starttls_auto)
    delivery_options = {}
    if (_authentication == 'ntlm')
      delivery_options = {
          :address => _address,
          :port => _port,
          :domain => _domain,
          :user_name => _user_name,
          :password => _password,
          :authentication => :ntlm,
          :enable_starttls_auto => true
      }
    else
      delivery_options = {
          :address => _address,
          :port => _port,
          :domain => _domain,
          :user_name => _user_name,
          :password => _password,
          :authentication => _authentication,
          :enable_starttls_auto => true
      }
    end
    return delivery_options
  end

  def convertTimestampToDateTime(timestamp)
    return (Time.at(timestamp).to_datetime).strftime("%d-%m-%Y %H:%M:%S")
  end

  def distance_between(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    rm = 6371000 # Earth radius in meters

    lat1_rad, lat2_rad = lat1 * rad_per_deg, lat2 * rad_per_deg
    lon1_rad, lon2_rad = lon1 * rad_per_deg, lon2 * rad_per_deg

    a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

    rm * c # Delta in meters
  end
end