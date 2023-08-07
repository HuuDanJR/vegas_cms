module RouletteModule
  include CommonModule
  include DaoModule

  ROULETTE_ATTRIBUTE = ClassAttribute.new
  ROULETTE_ATTRIBUTE.clazz = Roulette
  ROULETTE_ATTRIBUTE.object_key = "roulette"
  ROULETTE_ATTRIBUTE.filter_params = ["search"]
  ROULETTE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  ROULETTE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  ROULETTE_ATTRIBUTE.include_object_params = {}

end