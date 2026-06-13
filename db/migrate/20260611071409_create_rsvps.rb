class CreateRsvps < ActiveRecord::Migration[8.1]
  def change
    create_table :rsvps do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :rsvps, [:guest_id, :event_id], unique: true
    add_index :rsvps, :status
  end
end
