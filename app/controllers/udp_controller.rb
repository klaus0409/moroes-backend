require 'socket'

# DEPRECATED: 使用 CommandController @gaohui 2017.07.25
class UdpController < ApplicationController
  skip_before_action :verify_authenticity_token

  def startup_app
    device_id = params[:device_id]
    device = Device.find(device_id)
    app_name, app_version = if params[:app_id].present?
                              app = App.find(params[:app_id])
                              [app.name, app.version]
                            else
                              ["", ""]
                            end

    UDPService.startup_app current_user.id, device.id, app_name, app_version
    render json: { success: true, msg: "命令发送成功" }
  rescue => e
    puts e
    render json: { success: false, msg: "命令发送失败" }
  end


  def shutdown
    device_id = params[:device_id]
    device = Device.find(device_id)
    museum_name = device.museum.try(:name) || ""

    UDPService.shutdown_msg current_user.id, device_id, museum_name
    render json: { success: true, msg: "命令发送成功" }
  rescue => e
    puts e
    render json: { success: false, msg: "命令发送失败" }
  end

  private

end