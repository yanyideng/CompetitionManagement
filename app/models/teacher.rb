class Teacher < ApplicationRecord
  has_many :groups, through: :guide_teachers
  belongs_to :college
end
