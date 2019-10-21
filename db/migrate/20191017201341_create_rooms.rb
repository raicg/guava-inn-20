class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :code, null: false, unique: true
      t.integer :capacity, null: false
      t.text :notes

      t.timestamps
    end
  end
end
