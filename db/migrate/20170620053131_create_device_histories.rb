class CreateDeviceHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :device_histories, :options => "ENGINE=MyISAM"  do |t|
      t.integer :device_id, null: false
      t.integer :app_id
      t.integer :event_type, null: false
      t.datetime :timestamp, null: false
    end
  end
end
