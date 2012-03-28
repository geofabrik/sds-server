class OsmShadowsController < ApplicationController
   before_filter :authenticate,  :only => [:index, :show, :new, :edit, :create]
   before_filter :change_project, :only => [:show, :new, :edit]


   require 'xml/libxml'
   require 'pp'

   def index
      redirect_to tagsearch_path
   end


   def show
      @title = "Object Properties"
      retrieve_object
   end


   def edit 
      @title = "Edit Tags"
      retrieve_object
   end


   def new
      @title = "New Tags"
      retrieve_object

      if (@osm_shadow.nil?) then
         @osm_shadow = OsmShadow.new
         @osm_shadow.osm_type = params[:osm_type]
         @osm_shadow.osm_id = params[:osm_id]
         @tags = Array.new
         @taghash = Hash.new
      end

      current_user.zoom = params['zoom'];
      current_user.lon  = params['lon'];
      current_user.lat  = params['lat'];
      current_user.save!
   end


   def create
      if (!current_changeset.nil?) then
         params['changeset_id'] = current_changeset.id
      elsif (!current_user.nil?) then
         changeset = Changeset.new
         changeset.user_id = current_user.id
         changeset.save!
         store_changeset(changeset)
         params['changeset_id'] = changeset.id
      end

      shadow = OsmShadow.from_params(params)
      saved = shadow.save_with_current

      flash[:success]= "Object successfully saved."
      redirect_to :action => "show", :osm_type => shadow.osm_type, :osm_id => shadow.osm_id
   end

private
   def retrieve_object
      @osm_shadow = OsmShadow.find_current(params[:osm_type], params[:osm_id])
      @tags = Array.new
      @taghash = Hash.new
      if (!@osm_shadow.nil?) then
         @osm_shadow.tags.each do |tag|
            @tags.push(tag)
            @taghash[tag.key] = tag.value
         end
      end
   end


   def change_project
      @user = current_user
      if !params['change_project'].blank? then
         current_user.project_id = params['change_project']
         current_user.save!
      end
   end
end
