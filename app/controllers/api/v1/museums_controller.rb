class Api::V1::MuseumsController < Api::V1::BaseController

  api! "博物馆详情"
  def show
    @museum = Museum.find params[:id]
    render json: @museum
  end

end
