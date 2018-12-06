class AddActionToIntent < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :action, :integer
    add_column :intents, :user_id, :integer
  end
end
