class CurrentOsmShadow < ActiveRecord::Base
   include OsmShadowXmlConverter

   attr_accessible :osm_id, :osm_type, :version, :changeset_id
   has_many :tags, :class_name => "CurrentTag", :dependent => :destroy
   belongs_to :changeset

   validates :osm_type, :presence => true, :inclusion => { :in => ["node", "way", "relation"]}
   validates :osm_id, :presence => true, :numericality => true
   validates :changeset_id, :presence => true, :numericality => true
   validates :version, :presence => true, :numericality => true

   validates_uniqueness_of :osm_id, :scope => :osm_type

   default_scope :order => 'current_osm_shadows.created_at DESC' # newest first
end
