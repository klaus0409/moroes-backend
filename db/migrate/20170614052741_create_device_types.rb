class CreateDeviceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :device_types do |t|
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end
