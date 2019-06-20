class Teacher < ApplicationRecord
  has_many :groups, through: :guide_teachers
  belongs_to :college

  validates :teacher_id, presence: true
  validates :name, presence: true
end
