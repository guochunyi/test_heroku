class AddLoginTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :login_time, :integer, default: 0
  end
end
