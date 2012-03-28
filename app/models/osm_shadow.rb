class OsmShadow < ActiveRecord::Base
   include OsmShadowXmlConverter

   attr_accessible :osm_id, :osm_type, :version, :changeset_id
   before_create :generate_version

   belongs_to :changeset
   has_many :tags, :dependent => :destroy

   validates :changeset_id, :presence => true
   validates :osm_type, :presence => true, :inclusion => { :in => ["node", "way", "relation"]}
   validates :osm_id, :presence => true, :numericality => {:less_than_or_equal_to => 9223372036854775807}

   validates_uniqueness_of :osm_id, :scope => [:osm_type, :version]
   default_scope :order => 'osm_shadows.created_at DESC' # newest first

   
   def save_with_current
      if !self.new_record?
         return false
      end

      shadow = OsmShadow.new({
         :osm_type      => osm_type, 
         :osm_id        => osm_id,
         :changeset_id  => changeset_id
      })
      shadow.save!
      self.id = shadow.id
      self.version = shadow.version

      self.tags.each do |t|
         shadow.tags.create!({
            :key            => t.key,
            :value          => t.value
         })
      end

      update_current
      return shadow
   end

   def update_current
      CurrentOsmShadow.destroy_all({:osm_type => osm_type, :osm_id => osm_id})

      # no entry in current tables if there are no tags
      if self.tags.length == 0 then
         return nil
      end

      current_shadow = CurrentOsmShadow.new({
         :osm_type      => osm_type,
         :osm_id        => osm_id,
         :changeset_id  => changeset_id,
         :version       => version
      })
      current_shadow.save!

      self.tags.each do |t|
         unless (t.key.blank? or t.value.blank?) then
            current_shadow.tags.create!({
               :key                     => t.key,
               :value                   => t.value
            })
         end
      end
   end

   def self.find_current(otype, oid)
      collection = CurrentOsmShadow.where("osm_type = ? and osm_id = ?", otype, oid)
      if (collection.length > 0) then
         shadow = collection.first
         shadow.tags = CurrentTag.where("current_osm_shadow_id = ?", shadow.id)
         return shadow
      end
      return nil
   end


   def self.current_from_collectshadows_params(params)
      shadows = Array.new

      ['nodes', 'ways', 'relations'].each do |ot|
         unless (params[ot].nil?) then
            shadows = shadows + CurrentOsmShadow.where("osm_type = '#{ot.chomp('s')}' and osm_id IN (?)", params[ot].split(','))
         end
      end

      return shadows
   end


   def self.from_params(params)
      shadow = OsmShadow.new({
         'osm_id' => params['osm_shadow']['osm_id'],
         'osm_type' => params['osm_shadow']['osm_type'],
         'changeset_id' => params['changeset_id']
      })

      if (!params['tags'].nil?) then
         i = 0
         while i < params['tags']['key'].length
            shadow.add_tag(params['tags']['key'][i], params['tags']['value'][i])
            i += 1
         end
      elsif (!params['taghash'].nil?) then
         params['taghash'].each do |key, value|
            if (params['unselected_value'].nil?) then
               shadow.add_tag(key, value)
            elsif (value != params['unselected_value']) then
               shadow.add_tag(key, value)
            end
         end
      end
      return shadow
   end

   
   def add_tag(key, value)
      tag = Tag.new
      tag.key = key
      tag.value = value
      self.tags << tag unless key.blank?
   end

private
   def generate_version
      version = OsmShadow.where("osm_id = ? and osm_type = ?", self.osm_id, self.osm_type).maximum("version")
      if version.nil?
         self.version = 1
      else
         self.version = version + 1
      end
   end

end
