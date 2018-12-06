module Command
  include ActiveSupport::Concern

  def start_command
    devices = Device.find params[:devices]

    tcp_service = TcpService.new(Settings.tcp_server.host, Settings.tcp_server.port)
    devices.each do |device|
      command = device.start_command
      if command.present? && device.is_off?
        Intent.create(user_id: current_user.id, device_id: device.id, action: :start_device, timestamp: Time.current)
        tcp_service.send_command(device.id, command.to_json)
      end
    end

    tcp_service.close

    render json: { success: true }
  rescue => e
    puts e
    render json: { success: false, error: e.message }
  end


  def stop_command
    devices = Device.find params[:devices]

    tcp_service = TcpService.new(Settings.tcp_server.host, Settings.tcp_server.port)
    devices.each do |device|
      command = device.stop_command
      if command.present? && device.is_running?
        Intent.create(user_id: current_user.id, device_id: device.id, action: :stop_device, timestamp: Time.current)
        tcp_service.send_command(device.id, command.to_json)
      end
    end

    tcp_service.close

    render json: { success: true }
  rescue => e
    puts e
    render json: { success: false, error: e.message }
  end


  def broadcast_message
    devices = Device.find params[:devices]
    duration = params[:duration].to_i

    tcp_service = TcpService.new(Settings.tcp_server.host, Settings.tcp_server.port)
    devices.each do |device|
      Intent.create(user_id: current_user.id, device_id: device.id, action: :broadcast_message, timestamp: Time.current)
      tcp_service.broadcast_msg(device.id, duration, params[:msg])
    end

    tcp_service.close

    render json: { success: true }
  rescue => e
    puts e.backtrace.join("\r\n")
    render json: { success: false, error: e.message }
  end

  def start_app
    tcp_service = TcpService.new(Settings.tcp_server.host, Settings.tcp_server.port)

    params.require(:devices).permit!.to_hash.each do |_, device|
      device_id = device['device_id'].to_i
      app_id = device['app_id'].to_i
      if app_id == 0
        # 切换应用到空闲
        tcp_service.start_app(device_id, app_id, "", "")
      else
        app = App.find app_id
        Intent.create(user_id: current_user.id, device_id: device_id, action: :start_app, timestamp: Time.current, app_id: app_id)
        tcp_service.start_app(device_id, app_id, app.name, app.version)
      end
    end

    tcp_service.close

    render json: { success: true }
  rescue => e
    puts e.backtrace.join("\r\n")
    render json: { success: false, error: e.message }
  end
end