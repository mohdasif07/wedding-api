class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :event, foreign_key: true
      t.references :album, foreign_key: true
      t.string :caption

      t.timestamps
    end

    add_index :photos, :created_at
  end
end
