class Api::V1::BaseController < Api::V1::ApiApplicationController
  before_action :set_object, only: [:show, :update]
  before_action :check_request_body, only: [:create, :update]

  include DaoModule
  include ValidationModule
  include RedisCacheModule

  def initialize(class_attribute)
    self.class_attribute = class_attribute
  end

  # GET /objects
  def index
    # Get cache data
    cache_key = redis_cache_generate_key_get_all(self.class_attribute.filter_params, self.class_attribute.clazz, __method__)
    cache_data = redis_cache_get(cache_key)
    if !(cache_data.nil?)
      render_success_json(SuccessData.new(:ok, JSON.parse(cache_data)), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
      return
    end

    result = check_validate_get_all(self.class_attribute.clazz, self.class_attribute.include_object_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_all_object(self.class_attribute.clazz, self.class_attribute.filter_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params), cache_key)
  end

  # GET /objects/:id
  def show
    # Get cache data
    cache_key = redis_cache_generate_key_get_by_id(self.class_attribute.clazz, __method__)
    cache_data = redis_cache_get(cache_key)
    if !(cache_data.nil?)
      render_success_json(SuccessData.new(:ok, JSON.parse(cache_data)), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
      return
    end

    result = check_validate_get_by_id(self.class_attribute.clazz, self.class_attribute.include_object_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_object_by_id(self.class_attribute.clazz, params[:id], params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.show_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params), cache_key)
  end

  # POST /objects
  def create
    # Check params require, params option, value params
    # Need override function "check_params_create_or_update" in concrete class
    result = check_params_create_or_update(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    # Need override function "create_object" in concrete class
    result = create_object(self.class_attribute.clazz, self.class_attribute.object_key, self.class_attribute.create_params)
    if result.result == true
      render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.create_except_params)
    else
      render_error_json(ErrorData.new(result.status, result.exception))
    end
  end

  # PUT /objects/:id
  def update
    # Check params require, params option, value params
    # Need override function "check_params_create_or_update" in concrete class
    result = check_params_create_or_update(@request_body, @object.id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    # Need override function "update_object" in concrete class
    result = update_object(@object, self.class_attribute.object_key, self.class_attribute.update_params, @request_body)
    if result.result == true
      render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.update_except_params)
    else
      render_error_json(ErrorData.new(result.status, result.exception))
    end
  end

  protected

  attr_accessor :class_attribute

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_object
    result = get_object_by_id(self.class_attribute.clazz, params[:id])
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
    else
      @object = result.data
    end
  end

end
