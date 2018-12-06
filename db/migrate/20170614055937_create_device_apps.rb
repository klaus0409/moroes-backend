class CreateDeviceApps < ActiveRecord::Migration[5.1]
  def change
    create_table :device_apps do |t|
      t.integer :device_id
      t.integer :app_id
      t.string :note

      t.timestamps
    end
  end
end
