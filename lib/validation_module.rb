module ValidationModule
  include CommonModule
  include DaoModule

  # Validate input params get all
  def check_validate_get_all(clazz, include_object_params, input_params)
    result = ResultHandler.new

    # Check fields param
    if (!check_param_field(clazz, input_params['fields']))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    # Check order param
    if (!check_param_order(clazz, input_params['sort']))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    # Check limit, offset paging param
    if (!check_param_paging(input_params['limit'], input_params['offset']))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    # Check include related clazz
    if !check_param_include_object(include_object_params, input_params['include'])
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  # Validate input params get by id
  def check_validate_get_by_id(clazz, include_object_params, input_params)
    result = ResultHandler.new

    # Check fields param
    if (!check_param_field(clazz, input_params['fields']))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    # Check include related clazz
    if !check_param_include_object(include_object_params, input_params['include'])
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  # Validate input params create/update object
  def check_params_create_or_update(_request_body, _id = nil)
    result = ResultHandler.new
    return result
  end

  # Validate input param update status
  def check_params_update_status(request_body)
    result = ResultHandler.new
    status_prop = request_body['status']

    if (is_blank(status_prop) || !is_number(status_prop))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  # Validate object exist by fields
  def check_object_exist_by_fields(clazz, fields, values)
    return get_object_by_fields(clazz, fields, values).result
  end

  # Validate object exist by fields except id
  def check_object_exist_by_fields_except_id(clazz, fields, values, id)
    return get_object_by_fields(clazz, fields, values, id).result
  end

  # Validate object exist by id
  def check_object_exist_by_id(clazz, id)
    return get_object_by_id(clazz, id).result
  end

  def check_validate_paging(page, items_per_page)
    result = ResultHandler.new
    if is_blank(page)
      result.set_error_data(:bad_request, I18n.t('messages.page_number_require'))
      return result
    end

    if is_blank(items_per_page)
      result.set_error_data(:bad_request, I18n.t('messages.items_per_page_require'))
      return result
    end

    if !is_number(page) || page.to_i <= 0
      result.set_error_data(:bad_request, I18n.t('messages.page_number_invalid'))
      return result
    end

    if !is_number(items_per_page) || items_per_page.to_i <= 0
      result.set_error_data(:bad_request, I18n.t('messages.items_per_page_invalid'))
      return result
    end
    return result
  end

  private

  def check_param_field(clazz, fields)
    if (is_blank(fields))
      return true
    end

    column_names = clazz.column_names
    fields_arr = fields.split(',').map(&:strip)
    fields_arr.each do |item|
      if (!column_names.include?(item))
        return false
      end
    end

    return true
  end

  def check_param_order(clazz, sort)
    if (is_blank(sort))
      return true
    end

    column_names = clazz.column_names
    fields_arr = sort.split(',').map(&:strip)
    fields_arr.each do |item|
      item_length = item.length

      if (item_length <= 1)
        return false
      end

      first_character = item[0, 1]
      if ((first_character.eql? '-') && !column_names.include?(item[1, item_length - 1]))
        return false
      end
      if (!(first_character.eql? '-') && !column_names.include?(item))
        return false
      end
    end

    return true
  end

  def check_param_paging(limit, offset)
    if (!check_param_limit(limit) || !check_param_offset(offset))
      return false
    end

    return true
  end

  def check_param_limit(limit)
    if (is_blank(limit))
      return true
    end

    begin
      limit_number = Integer(limit)
    rescue ArgumentError => e
      return false
    end

    if (limit_number <= 0 || limit_number > PAGING_CONFIG_API[:LIMIT])
      return false
    end

    return true
  end

  def check_param_offset(offset)
    if (is_blank(offset))
      return true
    end

    begin
      limit_number = Integer(offset)
    rescue ArgumentError => e
      return false
    end

    if (limit_number < 0)
      return false
    end

    return true
  end

  def check_param_include_object(include_object_params, include_clazzs_input)
    if is_blank(include_clazzs_input)
      return true
    end

    related_clazzs_list = include_clazzs_input.split('.').map(&:strip)
    related_clazzs_list.each do |clazz_item|
      if !include_object_params.has_key? clazz_item
        return false
      end
    end

    return true
  end

end