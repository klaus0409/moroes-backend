class IntentsController < ApplicationController
  def index
    @device = Device.find params[:device_id]
    @intents = @device.intents.includes(:event_type, :app).order(timestamp: :desc)
  end
end
