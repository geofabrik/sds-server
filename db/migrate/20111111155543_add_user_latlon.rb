class AddUserLatlon < ActiveRecord::Migration
   def up
      add_column :users, :zoom, :integer, :default => 5
      add_column :users, :lat, :float, :default => 0
      add_column :users, :lon, :float, :default => 0
   end

  def down
  end
end
