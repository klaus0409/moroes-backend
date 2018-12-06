json.array! @devices do |device|
  json.extract! device, :id, :name, :museum_id, :is_active, :app_id, :status, :note, :address, :created_at
  json.set! :type_name, device.device_type.name
  json.set! :type_id, device.device_type.id

  json.apps device.apps do |app|
    json.extract! app, :id, :name, :version, :note
    json.set! :link, api_v1_app_url(app, format: :json)
  end
end