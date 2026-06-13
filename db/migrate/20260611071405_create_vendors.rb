class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :vendor_name, null: false
      t.integer :vendor_type, null: false, default: 0
      t.string :contact_person
      t.string :phone
      t.string :email
      t.decimal :contract_amount, precision: 12, scale: 2, default: 0
      t.decimal :paid_amount, precision: 12, scale: 2, default: 0
      t.text :notes

      t.timestamps
    end

    add_index :vendors, :vendor_type
    add_index :vendors, [:user_id, :vendor_name]
  end
end
