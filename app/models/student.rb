class Student < ApplicationRecord
  has_many :groups, dependent: :destroy
  belongs_to :college
end
