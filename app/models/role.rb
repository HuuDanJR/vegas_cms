class Role < ApplicationRecord
  has_many :group_roles, dependent: :destroy
  has_many :groups, through: :group_roles
end
