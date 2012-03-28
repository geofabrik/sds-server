class Changeset < ActiveRecord::Base
   attr_accessible :user_id
   belongs_to :user
   has_many :osm_shadows, :dependent => :destroy

   validates :user_id, :presence => true
   default_scope :order => 'changesets.created_at DESC' # newest first

end
