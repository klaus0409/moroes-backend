class Device < ApplicationRecord
  extend Enumerize

  belongs_to :device_type
  belongs_to :museum, optional: true
  has_many :device_apps, dependent: :destroy
  has_many :apps, through: :device_apps
  has_many :intents, dependent: :nullify
  belongs_to :current_status, optional: true, class_name: 'EventType', foreign_key: 'status'
  # TODO 要在 apps 里面
  belongs_to :default_app, class_name: 'App', optional: true

  belongs_to :power_controller, optional: true
  has_one :power_controller_port

  validates :name, :device_type_id, presence: true
  validates :name, uniqueness: { scope: :museum_id }
  validates :port_index, inclusion: { in: [1, 2] }, if: 'power_controller.present?'
  validate :validate_default_app, if: 'default_app_id.present?'

  enumerize :start_cmd, in: %w[NONE BOOT_MANUAL BOOT_AUTO BOOT_PROJECTOR], default: "NONE"
  enumerize :stop_cmd, in: %w[NONE SOFT_SHUTDOWN_PC SHUTDOWN_PC SHUTDOWN_PROJECTOR], default: "NONE"

  scope :active, -> { where(is_active: true) }


  def start_command
    case self.start_cmd
      when "BOOT_MANUAL" then
        if power_controller.present? && port_index.present?
          PowerControllerService.boot_manual(self.power_controller.pid, self.port_index)
        end
      when "BOOT_AUTO" then
        if power_controller.present? && port_index.present?
          PowerControllerService.boot_auto(self.power_controller.pid, self.port_index)
        end
      when "BOOT_PROJECTOR" then
        if power_controller.present?
          PowerControllerService.boot_projector(self.power_controller.pid)
        end
    end
  end

  def stop_command
    case self.stop_cmd
      when "SOFT_SHUTDOWN_PC" then
        PowerControllerService.soft_shutdown_pc(self.id)
      when "SHUTDOWN_PC" then
        if self.power_controller.present?
          PowerControllerService.shutdown_pc(self.id, self.power_controller.pid, self.port_index)
        end
      when "SHUTDOWN_PROJECTOR" then
        if self.power_controller.present?
          PowerControllerService.shutdown_projector(self.id, self.power_controller.pid)
        end
    end
  end

  def is_running?
    if current_status.present?
      current_status.id.in? [2, 4, 5, 6, 7]
    else
      false
    end
  end

  def is_off?
    if current_status.present?
      current_status.id.in? [1, 3]
    else
      true
    end
  end

  private
  def validate_default_app
    unless self.apps.map(&:id).include? default_app_id
      self.errors.add('default_app_id', "必须在设备应用中选择")
    end
  end
end
