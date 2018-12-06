class DeviceApp < ApplicationRecord
  belongs_to :device
  belongs_to :app

  validates :device_id, :app_id, presence: true
  validates :app_id, uniqueness: { scope: :device_id }
end
