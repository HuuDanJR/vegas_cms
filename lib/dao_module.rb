module DaoModule
  include CommonModule
  include HttpModule

  # Create new object and save it into database
  def create_object(clazz, object_key, create_params)
    result = ResultHandler.new
    object = clazz.new(get_data_object_request_body(object_key, create_params))
    object = initialize_new_object(object)
    logger.debug "New object: #{object.attributes.inspect}"
    logger.debug "Object should be valid: #{object.valid?}"
    ActiveRecord::Base::transaction do
      if object.save
        logger.debug "The object was saved and now the user is going to be redirected..."
        result.set_success_data(:created, object)
      else
        result.set_error_data(:unprocessable_entity, object.errors)
        raise ActiveRecord::Rollback
      end
    end

    return result
  end

  # Update a object into database
  def update_object(object, object_key, update_params, request_body = nil)
    return update_object_abstract(object, object_key, update_params)
  end

  # Get all object from database
  def get_all_object(clazz, clazz_filter_params, input_params, query = nil, order_field = nil)
    result = ResultHandler.new

    # Get query data
    query_select = return_data_param_field(input_params['fields'])
    query_order = return_data_param_order(input_params['sort'])
    query_limit = return_data_param_limit(input_params['limit'])
    query_offset = return_data_param_offset(input_params['offset'])
    query_include = return_data_param_include(input_params['include'])

    logger.debug "Get all object: #{clazz}"
    logger.debug "Input params: #{input_params}"
    begin
      records = clazz.filter(filtering_params(params, clazz_filter_params))
      # total = records.count
      query_include.each do |item|
        records = records.includes(item)
      end
      if !query.nil?
        records = records.where(query)
      end
      records = records.select(query_select)
                    .order(query_order)
                    .order(order_field)
                    .limit(query_limit)
                    .offset(query_offset)
      # result.set_success_data_paging(:ok, records, total)
      result.set_success_data(:ok, records)
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

  # Get a object by id
  def get_object_by_id(clazz, id, input_params = nil)
    query_select = nil
    query_include = []

    if !input_params.nil?
      query_select = return_data_param_field(input_params['fields'])
      query_include = return_data_param_include(input_params['include'])
    end

    return get_object_by_id_abstract(clazz, id, query_select, query_include)
  end

  # Get object by fields
  def get_object_by_fields(clazz, fields, values, _id = 0)
    result = ResultHandler.new
    if (fields.length != values.length || is_blank(fields))
      return result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
    end

    condition_str = "  "
    for i in 0..(fields.length - 1)
      condition_str += " AND " + fields[i].to_s + " = '" + values[i].to_s + "'"
    end

    if (_id > 0)
      if (condition_str.include? "id")
        return result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
      end
      condition_str += " AND id != " + _id.to_s
    end

    object = clazz.where(condition_str).first
    if (!is_blank(object))
      result.set_success_data(:ok, object)
    else
      result.set_error_data(:not_found, I18n.t('messages.object_not_found'))
    end
    return result
  end

  # Initial value of new object
  def initialize_new_object(_object)
    obj = _object
    obj.status = OBJECT_STATUS[:ACTIVE]
    time_now = Time.now.to_i
    obj.created_at = time_now
    obj.updated_at = time_now
    return obj
  end

  private

  def get_object_by_id_abstract(clazz, id, select_params = nil, query_include = [])
    result = ResultHandler.new

    # Get query data
    query_select = '*'
    if !select_params.nil?
      query_select = select_params
    end

    logger.debug "Get object by id: #{clazz} - #{id}"
    logger.debug "Query select: #{query_select}"
    begin
      record = clazz.select(query_select)
      if record.nil?
        result.set_error_data(:not_found, I18n.t('messages.object_not_found'))
      else
        query_include.each do |item|
          record = record.includes(item)
        end
        record = record.find(id)
        result.set_success_data(:ok, record)
      end
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

  def update_object_abstract(object, object_key, update_params)
    result = ResultHandler.new
    object.updated_at = Time.now.to_i

    logger.debug "Update object: #{object.attributes.inspect}"
    logger.debug "Object should be valid: #{object.valid?}"
    ActiveRecord::Base::transaction do
      if object.update(get_data_object_request_body(object_key, update_params))
        logger.debug "The object was saved and now the user is going to be redirected..."
        result.set_success_data(:ok, object)
      else
        result.set_error_data(:unprocessable_entity, object.errors)
        raise ActiveRecord::Rollback
      end
    end

    return result
  end

end