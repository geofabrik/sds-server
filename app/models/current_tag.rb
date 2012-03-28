class CurrentTag < ActiveRecord::Base
   attr_accessible :key, :value
   belongs_to :current_osm_shadow

   validates :key, :presence => true
   # validates :value, :presence => true
   validates :current_osm_shadow_id, :presence => true

end
