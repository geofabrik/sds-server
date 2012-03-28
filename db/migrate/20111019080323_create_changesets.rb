class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.references :user

      t.timestamps
    end
    add_index :changesets, :user_id
  end
end
