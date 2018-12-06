json.extract! device, :id, :name, :museum_id, :device_type_id, :address, :is_active, :note, :created_at, :updated_at
json.url device_url(device, format: :json)
