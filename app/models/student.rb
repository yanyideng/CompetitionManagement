class Student < ApplicationRecord
  has_many :groups, dependent: :destroy
  belongs_to :college

  has_secure_password
  validates :password, :length => { :minimum => 5 }
  validates :student_id, presence: true
  validates :name, presence: true
end
