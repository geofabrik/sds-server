class CreateOsmShadows < ActiveRecord::Migration
  def change
    create_table :osm_shadows do |t|
      t.string :osm_type
      t.integer :osm_id, :limit => 8
      t.integer :version
      t.references :changeset

      t.timestamps
    end
    add_index :osm_shadows, :changeset_id
  end
end
