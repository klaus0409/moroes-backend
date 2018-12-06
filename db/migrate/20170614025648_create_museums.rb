class CreateMuseums < ActiveRecord::Migration[5.1]
  def change
    create_table :museums do |t|
      t.string :name
      t.string :address
      t.string :note

      t.timestamps
    end
  end
end
