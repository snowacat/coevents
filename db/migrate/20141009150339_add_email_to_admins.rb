class AddEmailToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :email, :string
  end
end
