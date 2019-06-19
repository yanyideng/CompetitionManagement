class College < ApplicationRecord
  has_many :teachers, dependent: :destroy
  has_many :students, dependent: :destroy
  validates :name, presence: true
end
