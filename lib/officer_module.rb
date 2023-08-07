module OfficerModule
  include CommonModule
  include DaoModule

  OFFICER_ATTRIBUTE = ClassAttribute.new
  OFFICER_ATTRIBUTE.clazz = Officer
  OFFICER_ATTRIBUTE.object_key = "officer"
  OFFICER_ATTRIBUTE.filter_params = ["search"]
  OFFICER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  OFFICER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFICER_ATTRIBUTE.include_object_params = {
      "attachments" => ["id", "name", "category"]
  }

end