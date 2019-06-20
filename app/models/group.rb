class Group < ApplicationRecord
  has_one :achievement, dependent: :destroy
  has_one :teacher, through: :guide_teachers
  belongs_to :student
  belongs_to :competition
end
