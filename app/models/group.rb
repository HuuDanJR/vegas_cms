class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :group_roles, dependent: :destroy
  has_many :roles, through: :group_roles
end
