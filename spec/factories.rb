# By using the symbol :user we get Factory Girl to simulate the User model

Factory.define :user do |user|
   user.firstname                "Phil" 
   user.lastname                 "Losoph"
   user.email                    { Factory.next(:email) }
   user.association              :project
end

Factory.sequence :email do |n|
   "person-#{n}@geofabrik.de"
end

Factory.define :project do |p|
   p.name "BBB Home Owner"
   p.partial "bbb_home_owner"
end


Factory.define :changeset do |changeset|
   changeset.association :user
end

Factory.define :osm_shadow do |osm_shadow|
   osm_shadow.osm_type     "way"
   osm_shadow.osm_id       123
   osm_shadow.association  :changeset
end

Factory.define :tag do |tag|
   tag.key           "highway"
   tag.value         "my_separate_value"
   tag.association   :osm_shadow
end


Factory.define :current_osm_shadow do |osm_shadow|
   osm_shadow.osm_type     "way"
   osm_shadow.osm_id       123
   osm_shadow.version      2
   osm_shadow.association  :changeset
end

Factory.define :current_tag do |tag|
   tag.key           "current_highway"
   tag.value         "my_current_value"
   tag.association   :current_osm_shadow
end

