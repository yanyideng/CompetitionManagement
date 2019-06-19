class Competition < ApplicationRecord
  has_many :groups, dependent: :destroy
end
