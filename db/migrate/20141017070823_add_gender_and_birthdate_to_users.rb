class AddGenderAndBirthdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :integer, :limit => 1, :null => true
    add_column :users, :birthdate, :date, :null => false
  end
end
