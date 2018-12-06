class PowerControllerPort < ApplicationRecord
  extend Enumerize

  belongs_to :power_controller
  belongs_to :device, optional: true

  # validates :device_id, presence: true
  validates :index, uniqueness: { scope: :power_controller_id }

  enumerize :status, in: { open: 1, close: 0 }, default: :close
end
