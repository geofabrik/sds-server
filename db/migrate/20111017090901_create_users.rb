class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :firstname
      t.string  :lastname
      t.string  :email
      t.string  :password
      t.boolean :active, :default => true
      t.boolean :admin, :default => false

      t.timestamps
    end
  end
end
