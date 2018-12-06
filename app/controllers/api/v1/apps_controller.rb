class Api::V1::AppsController < Api::V1::BaseController

  api! "查询所有应用"
  example <<-JSON
[
    {
        "id": 1,
        "name": "guanniao",
        "version": "v1.0.0",
        "note": "观鸟捕蝉图"
    }
]
  JSON
  def index
    @apps = App.all
  end


  api! "应用详情"
  example <<-JSON
{
    "id": 1,
    "name": "guanniao",
    "version": "v1.0.0",
    "note": "观鸟捕蝉图"
}

  JSON
  def show
    @app = App.find params[:id]
  end
end
