class Intent < ApplicationRecord
  extend Enumerize

  belongs_to :device
  belongs_to :user
  belongs_to :app, optional: true
  belongs_to :event_type, foreign_key: :event_type, optional: true

  enumerize :action, in: { start_device: 1, stop_device: 2, start_app: 3, broadcast_message: 4 }

  validates :timestamp, presence: true
end
