class RenameDeviceIsRunning < ActiveRecord::Migration[5.1]
  def change
    rename_column(:devices, :is_run, :status)
  end
end
