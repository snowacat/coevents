class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, :null => false, :length => 256
      t.string :content, :null => false
      t.integer :category_id, :null => true

      t.boolean :paid, :null => false, :default => false
      t.decimal :payment_amount
      t.datetime :start_date, :null => false
      t.datetime :end_date, :null => false

      t.float :latitude, :null => false
      t.float :longitude, :null => false
      t.string :address

      t.timestamps
    end
  end
end
