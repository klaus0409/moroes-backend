class PowerControllerService
  class << self
    def boot_manual(power_id, port)
      [
        {
          command: "power_on",
          power_id: power_id,
          port: port,
        },
        {
          command: "sleep",
          second: 2,
        },
        {
          command: "flash_off",
          power_id: power_id,
          port: port + 2,
        },
        {
          command: "sleep",
          second: 60,
        },
      ]
    end

    def boot_auto(power_id, port)
      [
        {
          command: "re_power_on",
          power_id: power_id,
          port: port
        },
        {
          command: "sleep",
          second: 60,
        },
      ]
    end

    def soft_shutdown_pc(device_id)
      [
        {
          command: "shutdown",
          device_id: device_id
        },
        {
          command: "sleep",
          second: 120,
        }
      ]
    end

    def shutdown_pc(device_id, power_id, port)
      [
        {
          command: "shutdown",
          device_id: device_id
        },
        {
          command: "sleep",
          second: 120,
        },
        {
          command: "power_off",
          power_id: power_id,
          port: port,
        }
      ]
    end

    def boot_projector(power_id)
      [
        {
          command: "power_on",
          power_id: power_id,
          port: 2,
        },
        {
          command: "power_on",
          power_id: power_id,
          port: 1,
        },
        {
          command: "sleep",
          second: 2,
        },
        {
          command: "flash_off",
          power_id: power_id,
          port: 4,
        },
        {
          command: "sleep",
          second: 2,
        },
        {
          command: "flash_off",
          power_id: power_id,
          port: 1,
        },
      ]
    end

    def shutdown_projector(device_id, power_id)
      [
        {
          command: "shutdown",
          device_id: device_id
        },
        {
          command: "flash_off",
          power_id: power_id,
          port: 4,
        },
        {
          command: "sleep",
          second: 120,
        },
        {
          command: "power_off",
          power_id: power_id,
          port:  1,
        },
        {
          command: "sleep",
          seoncd: 2
        },
        {
          command: "power_off",
          power_id: power_id,
          port: 2
        }
      ]
    end
  end

end