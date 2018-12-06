class AddPowerCotnrollerToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :power_controller_id, :integer
    add_column :devices, :port_index, :integer
    add_column :devices, :start_cmd, :string
    add_column :devices, :stop_cmd, :string
  end
end
