class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, :limit => 64
      t.string :email, :limit => 128
      t.string :phone_number, :limit => 20
      t.string :nationality, :limit => 32
      t.boolean :verified, :default => false, :null => false
    end
  end
end
