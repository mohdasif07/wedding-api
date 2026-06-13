class AddInvitationFieldsToGuests < ActiveRecord::Migration[8.1]
  def change
    add_column :guests, :invited_at, :datetime
    add_column :guests, :invite_count, :integer, default: 0, null: false
  end
end
