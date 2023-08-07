class Officer < ApplicationRecord
    has_many :officer_attachments, dependent: :destroy
    has_many :attachments, through: :officer_attachments
    has_many :officer_languages, dependent: :destroy
    validates :name, presence: true

    include Filterable
    scope :search, -> (query) {where("name LIKE ?", "%#{query}%")}
end
