class PowerController < ApplicationRecord
  extend Enumerize

  belongs_to :museum
  has_many :ports, class_name: "PowerControllerPort", dependent: :destroy
  has_many :devices

  validates :pid, :museum_id, :device_type, presence: true
  enumerize :device_type, in: %w[DAM0400], default: 'DAM0400'
  enumerize :status, in: {offline: 0, online: 1}, default: :offline

  accepts_nested_attributes_for :ports

  after_update :update_pid

  # 创建控制器和他们的端口
  def self.create_controller(pc)
    PowerController.transaction do
      4.times do |i|
        pc.ports.build(index: i, pid: pc.pid)
      end

      pc.save!
    end
    true
  rescue => e
    Rails.logger.error e
    return false
  end

  private
  def update_pid
    if self.pid_changed?
      self.ports.update(pid: self.pid)
    end
  end
end
