class Admin < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :password, :length => { :minimum => 5 }
end
