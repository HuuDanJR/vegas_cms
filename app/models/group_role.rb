class GroupRole < ApplicationRecord
  belongs_to :group
  belongs_to :role
end
