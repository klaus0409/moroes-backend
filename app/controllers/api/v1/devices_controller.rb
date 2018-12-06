class Api::V1::DevicesController < Api::V1::BaseController


  api! "博物馆的设备列表"
  example <<-JSON
[
    {
        "id": 1,
        "name": "姜浩电脑",
        "type_name": "general",
        "type_id": 1,
        "museum_id": 1,
        "is_active": true,
        "app_id": null,
        "status": 1,
        "note": "",
        "address": "",
        "created_at": "2017-06-26T11:35:20.000+08:00",
        "apps": [
            {
                "id": 1,
                "name": "guanniao",
                "version": "v1.0.0",
                "note": "观鸟捕蝉图",
                "link": "http://0.0.0.0:3000/api/v1/apps/1.json"
            }
        ]
    }
]
  JSON
  def index
    @museum = Museum.find params[:museum_id]
    @devices = @museum.devices.active.order(:created_at)
  end

end
