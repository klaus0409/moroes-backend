class CreatePowerControllers < ActiveRecord::Migration[5.1]
  def change
    create_table :power_controllers do |t|
      t.string :pid, null: false
      t.string :name
      t.integer :museum_id
      t.string :device_type
      t.string :address
      t.integer :status
      t.string :note

      t.timestamps
    end

    create_table :power_controller_ports do |t|
      t.integer :power_controller_id
      t.string :pid, null: false
      t.integer :index
      t.integer :status
      t.integer :device_id
      t.string :note

      t.timestamps
    end

    add_index(:power_controllers, :pid, unique: true)
  end
end
