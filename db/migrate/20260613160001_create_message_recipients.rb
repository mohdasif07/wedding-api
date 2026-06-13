class CreateMessageRecipients < ActiveRecord::Migration[8.1]
  def change
    create_table :message_recipients do |t|
      t.references :message, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: true
      t.integer :channel, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.datetime :sent_at
      t.text :error_message

      t.timestamps
    end

    add_index :message_recipients, [:message_id, :guest_id], unique: true
    add_index :message_recipients, :status
  end
end
