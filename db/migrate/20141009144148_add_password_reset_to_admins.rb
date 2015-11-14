class AddPasswordResetToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :password_reset_token, :string
    add_column :admins, :password_reset_sent_at, :datetime
  end
end
