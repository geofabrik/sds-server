class CreateCurrentOsmShadows < ActiveRecord::Migration
  def change
    create_table :current_osm_shadows do |t|
      t.string :osm_type
      t.integer :osm_id, :limit => 8
      t.integer :version
      t.references :changeset

      t.timestamps
    end

    add_index :current_osm_shadows, [:osm_type, :osm_id], :unique => true, :name => 'by_osm_type_id'
  end
end
