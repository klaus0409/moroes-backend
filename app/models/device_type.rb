class DeviceType < ApplicationRecord

  validates :name, presence: true, uniqueness: true
end
