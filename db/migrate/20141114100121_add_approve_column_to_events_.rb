class AddApproveColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :send_message, :boolean, :null => false, :default => false
  end
end
