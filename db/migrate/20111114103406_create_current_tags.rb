class CreateCurrentTags < ActiveRecord::Migration
  def change
    create_table :current_tags do |t|
      t.string :key
      t.string :value
      t.references :current_osm_shadow

      t.timestamps
    end
    add_index :current_tags, :current_osm_shadow_id
  end
end
