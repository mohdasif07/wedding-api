class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, foreign_key: true
      t.string :subject, null: false
      t.text :body, null: false
      t.integer :message_type, null: false, default: 0

      t.timestamps
    end

    add_index :messages, :message_type
    add_index :messages, :created_at
  end
end
