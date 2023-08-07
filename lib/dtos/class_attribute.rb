class ClassAttribute
  attr_accessor :clazz,
                :table_name,
                :object_key,
                :filter_params,
                :create_params,
                :update_params,
                :index_except_params,
                :show_except_params,
                :create_except_params,
                :update_except_params,
                :update_status_except_params,
                :include_object_params

  def initialize()
    self.clazz = ''
    self.table_name = ''
    self.object_key = ''
    self.filter_params = []
    self.create_params = []
    self.update_params = []
    self.index_except_params = []
    self.show_except_params = []
    self.create_except_params = []
    self.update_except_params = []
    self.update_status_except_params = []
    self.include_object_params = {}
  end
end