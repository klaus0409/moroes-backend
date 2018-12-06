# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
{id: 1, name: "通信中断"},
{id: 2, name: "通信恢复"},
{id: 3, name: "关机"},
{id: 4, name: "应用安装"},
{id: 5, name: "应用启动"},
{id: 6, name: "有人使用"},
{id: 7, name: "应用空闲"},
].each do |event_type|
  EventType.create_with(name: event_type[:name]).find_or_create_by(id: event_type[:id])
end

[
{id: 1, name: "general", note: nil },
{id: 2, name: "kenict", note: nil },
{id: 3, name: "leapmotion", note: nil },
{id: 4, name: "touch", note: nil },
{id: 5, name: "vr", note: nil },
{id: 6, name: "guide", note: nil },
{id: 7, name: "monitor", note: nil },
].each do |device_type|
  DeviceType.create_with(device_type.slice(:name, :note)).find_or_create_by(id: device_type[:id])
end

[{email: "admin@microwise-system.com", password: "microwise"}].each do |user|
  User.create_with(password: user[:password]).find_or_create_by!(email: user[:email])
end