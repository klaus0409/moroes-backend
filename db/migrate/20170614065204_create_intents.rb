class CreateIntents < ActiveRecord::Migration[5.1]
  def change
    create_table :intents, :options => "ENGINE=MyISAM" do |t|
      t.integer :device_id
      t.integer :event_type
      t.integer :app_id
      t.datetime :timestamp

    end
  end
end
