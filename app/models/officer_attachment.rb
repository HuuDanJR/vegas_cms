class OfficerAttachment < ApplicationRecord
  belongs_to :officer
  belongs_to :attachment
end
