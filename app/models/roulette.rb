class Roulette < ApplicationRecord
    validates :name, presence: true

    include Filterable
    scope :search, -> (query) {where("name LIKE ?", "%#{query}%")}
end
