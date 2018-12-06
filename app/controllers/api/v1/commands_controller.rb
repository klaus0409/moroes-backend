class Api::V1::CommandsController < Api::V1::BaseController
  include Command

  api! "开机命令"
  param "devices[]", String, desc: "设备ID"
  def start_devices
    start_command
  end


  api! "关机"
  param "devices[]", String, desc: "设备ID"
  def stop_devices
    stop_command
  end


  api :POST, '/api/v1/command/broadcast_message', "推送消息"
  param "devices[]", String, desc: "设备ID"
  param "duration", Integer, desc: "循环播放时长（分钟）"
  param "msg", String, desc: "消息"
  def broadcast_message
    super
  end
end
