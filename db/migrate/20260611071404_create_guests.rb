class CreateGuests < ActiveRecord::Migration[8.1]
  def change
    create_table :guests do |t|
      t.references :event, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :email
      t.string :family_name
      t.integer :side, null: false, default: 0
      t.integer :rsvp_status, null: false, default: 0
      t.text :address
      t.string :qr_code_token, null: false

      t.timestamps
    end

    add_index :guests, :qr_code_token, unique: true
    add_index :guests, :rsvp_status
    add_index :guests, :side
    add_index :guests, [:event_id, :email]
  end
end
