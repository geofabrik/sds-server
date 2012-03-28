class Tag < ActiveRecord::Base
   attr_accessible :key, :value, :osm_shadow_id
   belongs_to :osm_shadow

   validates :key, :presence => true
   # validates :value, :presence => true
   validates :osm_shadow_id, :presence => true

end
