class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.datetime :checked_in_at, null: false

      t.timestamps
    end

    add_index :attendances, [:guest_id, :event_id], unique: true
  end
end
