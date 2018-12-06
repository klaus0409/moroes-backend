class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :museum_id
      t.integer :device_type_id
      t.string :address
      t.boolean :is_active
      t.integer :app_id
      t.integer :is_run
      t.string :note

      t.timestamps
    end
  end
end
