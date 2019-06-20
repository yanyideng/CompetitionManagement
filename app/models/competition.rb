class Competition < ApplicationRecord
  has_many :groups, dependent: :destroy
  validates :name, presence: true
  validates :version, presence: true
  validates :deadline, presence: true
  validates :endtime, presence: true
end
