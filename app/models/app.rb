class App < ApplicationRecord
  has_many :device_apps, dependent: :destroy

  validates :name, :version, presence: true
  validates :version, uniqueness: { scope: :name }

  def full_name
    "#{name}-#{version}"
  end
end
