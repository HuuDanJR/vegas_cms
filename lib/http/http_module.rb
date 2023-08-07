module HttpModule
  include CommonModule

  # A list of the param names that can be used for filtering the list
  def filtering_params(params, filter_params)
    params.slice(*filter_params)
  end

  def return_data_param_field(fields, clazz_name = nil)
    query_select = ''

    # Check fields param
    if (!is_blank(fields))
      fields_arr = fields.split(',').map(&:strip)
      query_select = fields_arr.join(', ')
    else
      if (!clazz_name.nil?)
        query_select = clazz_name + '.*'
      else
        query_select = '*'
      end
    end

    return query_select
  end

  def return_data_param_order(sort)
    query_order = ''

    # Check fields param
    if (!is_blank(sort))
      fields_arr = sort.split(',').map(&:strip)
      fields_arr_temp = []
      fields_arr.each do |item|
        if (item[0, 1].eql? '-')
          fields_arr_temp.push(item[1, item.length - 1] + ' DESC')
        else
          fields_arr_temp.push(item)
        end
      end
      query_order = fields_arr_temp.join(', ')
    end

    return query_order
  end

  def return_data_param_limit(limit)
    query_limit = PAGING_CONFIG_API[:LIMIT]

    if (!is_blank(limit))
      query_limit = limit.to_i
    end

    return query_limit
  end

  def return_data_param_offset(offset)
    query_offset = PAGING_CONFIG_API[:OFFSET]

    if (!is_blank(offset))
      query_offset = offset.to_i
    end

    return query_offset
  end

  def return_data_param_include(related_clazzs)
    related_class_arr = []

    # Check related class param
    if (!is_blank(related_clazzs))
      related_class_arr = related_clazzs.split('.').map(&:strip)
    end

    return related_class_arr
  end

  def return_data_param_number(param_number)
    query_number = 0

    if (!is_blank(param_number))
      query_number = param_number
    end

    return query_number
  end

  def attach_data_param_include(related_clazzs, include_params)
    include_objects_temp = {}

    # Check related class param
    related_class_arr = return_data_param_include(related_clazzs)
    if related_class_arr.length > 0
      related_class_arr.each do |item|
        include_objects_temp["#{item}"] = {only: include_params["#{item}"]}
      end
    end

    return include_objects_temp
  end

  # Get data object from request body
  def get_data_object_request_body(object_key, data_params)
    # params.require(object_key).permit(data_params)
    params.permit(data_params)
  end
end