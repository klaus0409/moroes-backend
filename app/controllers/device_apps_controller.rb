class DeviceAppsController < ApplicationController
  before_action :set_device, only: [:index, :new, :create, :update]
  before_action :set_device_app, only: [:show, :edit, :update, :destroy]

  # GET /device_apps
  # GET /device_apps.json
  def index
    @device = Device.find params[:device_id]
    @device_apps = @device.device_apps.all
  end

  # GET /device_apps/1
  # GET /device_apps/1.json
  def show
  end

  # GET /device_apps/new
  def new
    @device_app = DeviceApp.new(device: @device)
  end

  # GET /device_apps/1/edit
  def edit
  end

  # POST /device_apps
  # POST /device_apps.json
  def create
    @device_app = DeviceApp.new(device_app_params)

    respond_to do |format|
      if @device_app.save
        format.html { redirect_to device_device_apps_path(@device), notice: 'Device app was successfully created.' }
        format.json { render :show, status: :created, location: @device_app }
      else
        format.html { render :new }
        format.json { render json: @device_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /device_apps/1
  # PATCH/PUT /device_apps/1.json
  def update
    respond_to do |format|
      if @device_app.update(device_app_params)
        format.html { redirect_to device_device_apps_path(@device), notice: 'Device app was successfully updated.' }
        format.json { render :show, status: :ok, location: @device_app }
      else
        format.html { render :edit }
        format.json { render json: @device_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_apps/1
  # DELETE /device_apps/1.json
  def destroy
    @device = @device_app.device
    @device_app.destroy
    respond_to do |format|
      format.html { redirect_to device_device_apps_path(@device), notice: 'Device app was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_device
      @device = Device.find params[:device_id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_device_app
      @device_app = DeviceApp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_app_params
      params.require(:device_app).permit(:device_id, :app_id, :note)
    end
end
