class PowerControllersController < ApplicationController
  before_action :set_power_controller, only: [:show, :edit, :update, :destroy]

  # GET /power_controllers
  # GET /power_controllers.json
  def index
    @power_controllers = PowerController.all
  end

  # GET /power_controllers/1
  # GET /power_controllers/1.json
  def show
  end

  # GET /power_controllers/new
  def new
    @power_controller = PowerController.new
  end

  # GET /power_controllers/1/edit
  def edit
  end

  # POST /power_controllers
  # POST /power_controllers.json
  def create
    @power_controller = PowerController.new(power_controller_params)

    respond_to do |format|
      if PowerController.create_controller(@power_controller)
        format.html { redirect_to @power_controller, notice: 'Power controller was successfully created.' }
        format.json { render :show, status: :created, location: @power_controller }
      else
        format.html { render :new }
        format.json { render json: @power_controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /power_controllers/1
  # PATCH/PUT /power_controllers/1.json
  def update
    respond_to do |format|
      if @power_controller.update(power_controller_params)
        format.html { redirect_to @power_controller, notice: 'Power controller was successfully updated.' }
        format.json { render :show, status: :ok, location: @power_controller }
      else
        format.html { render :edit }
        format.json { render json: @power_controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /power_controllers/1
  # DELETE /power_controllers/1.json
  def destroy
    @power_controller.destroy
    respond_to do |format|
      format.html { redirect_to power_controllers_url, notice: 'Power controller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_power_controller
      @power_controller = PowerController.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def power_controller_params
      params.require(:power_controller).permit(:pid, :name, :museum_id, :device_type, :address, :status, :note)
    end
end
