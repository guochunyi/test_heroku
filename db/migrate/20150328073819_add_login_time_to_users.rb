class AddLoginTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_count, :time, default: 0
  end
end
