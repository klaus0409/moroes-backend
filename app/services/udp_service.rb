class UDPService

  class << self
    def startup_app(user_id, device_id, app_name, app_version)
      send_message startup_app_msg(user_id, device_id, app_name, app_version)
    end

    def shutdown(user_id, device_id, museum_name)
      send_message shutdown_msg(user_id, device_id, museum_name)
    end

    def operate_switch(user_id, pid, port_index, onoff)
      send_message switch_msg(user_id, pid, port_index, onoff)
    end

    def send_message(msg)
      udp = UDPSocket.new
      udp.send msg, 0, Settings.udp_server.host, Settings.udp_server.port
      udp.close
    end


    def startup_app_msg(user_id, device_id, app_name, app_version)
      # {"id":"monitor","target":"lijun_pc","logType":"monitor control","strategy":"relay","quality":2,"timestamp":"1497492089649","contentBean":{"command":"restart","args":["guanniao","v2.0"]}}

      msg = {
        id: "user-#{user_id}",
        target: device_id.to_s,
        logType: "monitor control",
        strategy: "relay",
        quality: 2,
        timestamp: (Time.current.to_f * 1000).to_i,
        contentBean: {
          command: "restart",
          args: [app_name, app_version],
        }
      }.to_json

      puts msg

      msg
    end

    # {"id":"monitor","target":"lijun_pc","logType":"monitor control","strategy":"relay","quality":1,"timestamp":"1497496881917","contentBean":{"command":"shutdown","args":["我是高辉"]}}
    def shutdown_msg(user_id, device_id, museum_name)
      msg = {
        id: "user-#{user_id}",
        target: device_id.to_s,
        logType: "monitor control",
        strategy: "relay",
        quality: 1,
        timestamp: (Time.current.to_f * 1000).to_i,
        contentBean: {
          command: "shutdown",
          args: ["#{museum_name}集中管理平台已发出关机指令，本机将在1分钟后关闭。"]
        }
      }.to_json

      puts msg

      msg
    end

    # port_index 从 1 开始，onoff 1 表示开，0 表示关
    def switch_msg(user_id, pid, port_index, onoff)
      # {"id":"monitor","target":"JY05SfZdGcM0WDdO","logType":"path","strategy":"relay","quality":1,"timestamp":1494825498577,"contentBean":{"command":"setStatus","args":[1, 1]}}

      msg = {
        id: "user-#{user_id}",
        target: pid,
        logType: "path",
        strategy: "relay",
        quality: 1,
        timestamp: (Time.current.to_f * 1000).to_i,
        contentBean: {
          command: "setStatus",
          args: [port_index, onoff]
        }
      }.to_json

      puts msg

      msg
    end
  end
end