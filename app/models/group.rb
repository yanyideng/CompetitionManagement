class Group < ApplicationRecord
  belongs_to :student
  belongs_to :competition
end
