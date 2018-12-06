class DeviceHistory < ApplicationRecord
  belongs_to :device
  belongs_to :app, optional: false
  belongs_to :event_type, foreign_key: "event_type"
end
