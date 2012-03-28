# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111114103406) do

  create_table "changesets", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "changesets", ["user_id"], :name => "index_changesets_on_user_id"

  create_table "current_osm_shadows", :force => true do |t|
    t.string   "osm_type"
    t.integer  "osm_id",       :limit => 8
    t.integer  "version"
    t.integer  "changeset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_osm_shadows", ["osm_type", "osm_id"], :name => "by_osm_type_id", :unique => true

  create_table "current_tags", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "current_osm_shadow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_tags", ["current_osm_shadow_id"], :name => "index_current_tags_on_current_osm_shadow_id"

  create_table "osm_shadows", :force => true do |t|
    t.string   "osm_type"
    t.integer  "osm_id",       :limit => 8
    t.integer  "version"
    t.integer  "changeset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "osm_shadows", ["changeset_id"], :name => "index_osm_shadows_on_changeset_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "partial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "osm_shadow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["osm_shadow_id"], :name => "index_tags_on_osm_shadow_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "password"
    t.boolean  "active",     :default => true
    t.boolean  "admin",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id", :default => 1
    t.integer  "zoom",       :default => 5
    t.float    "lat",        :default => 0.0
    t.float    "lon",        :default => 0.0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
