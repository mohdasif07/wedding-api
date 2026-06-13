class CreateAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :albums do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :albums, [:user_id, :title]
  end
end
