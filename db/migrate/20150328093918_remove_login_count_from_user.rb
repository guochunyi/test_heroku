class RemoveLoginCountFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :login_count, :time
  end
end
