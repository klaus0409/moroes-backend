class PowerControllerPortsController < ApplicationController


  def edit
    @port = PowerControllerPort.find params[:id]
    @power_controller = @port.power_controller
    @museum = @power_controller.museum
  end

  def update
    @port = PowerControllerPort.find params[:id]
    if @port.update(port_params)
      redirect_to power_controller_url(@port.power_controller), notice: "修改成功"
    else
      flash.now.alert = "修改失败"
      render :edit
    end
  end


  private
  def port_params
    params.require(:power_controller_port).permit(:index, :device_id, :note)
  end

end
