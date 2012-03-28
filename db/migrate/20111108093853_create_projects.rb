class CreateProjects < ActiveRecord::Migration
   def change
      create_table :projects do |t|
         t.string :name
         t.string :partial

         t.timestamps
      end

      add_column :users, :project_id, :integer, :default => 1

      # Project.create!(:name => "Generic", :partial => "generic")
      Project.create!(:name => "BBB Home Owner", :partial => "bbb_home_owner")
      Project.create!(:name => "BBB Door To Door", :partial => "bbb_door_door")
      Project.create!(:name => "ACCESS Poverty Mapping", :partial => "access_poverty_mapping")
      Project.create!(:name => "PNPM Poverty Mapping", :partial => "pnpm_poverty_mapping")

   end
end
