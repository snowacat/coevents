class AddAuthTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :auth_token, :string
    add_index  :admins, :auth_token
  end
end
