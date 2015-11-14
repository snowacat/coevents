class CreateCategory < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, :null => false
      t.integer :parent, :null => true
    end
    add_index :categories, :id
  end
end
