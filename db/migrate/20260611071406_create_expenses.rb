class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :category, null: false, default: 0
      t.decimal :estimated_amount, precision: 12, scale: 2, default: 0
      t.decimal :actual_amount, precision: 12, scale: 2, default: 0
      t.integer :payment_status, null: false, default: 0
      t.text :remarks

      t.timestamps
    end

    add_index :expenses, :category
    add_index :expenses, :payment_status
    add_index :expenses, :created_at
  end
end
