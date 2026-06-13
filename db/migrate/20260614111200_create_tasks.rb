class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :category, null: false, default: "general"
      t.integer :status, null: false, default: 0
      t.date :due_date
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :tasks, [:user_id, :status]
    add_index :tasks, [:user_id, :category]
  end
end
