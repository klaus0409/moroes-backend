class AddDefaultAppIdToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :default_app_id, :integer
  end
end
