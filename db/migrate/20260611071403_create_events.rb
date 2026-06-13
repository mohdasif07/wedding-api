class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :venue
      t.date :event_date, null: false
      t.time :start_time
      t.time :end_time
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :events, :event_date
    add_index :events, :status
    add_index :events, [:user_id, :title]
  end
end
