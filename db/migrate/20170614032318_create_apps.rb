class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :version
      t.string :note

      t.timestamps
    end
  end
end
