class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :key
      t.string :value
      t.references :osm_shadow

      t.timestamps
    end
    add_index :tags, :osm_shadow_id
  end
end
