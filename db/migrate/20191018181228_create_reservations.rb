class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :guest_name, null: false
      t.integer :number_of_guests, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
