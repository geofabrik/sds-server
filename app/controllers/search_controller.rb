class SearchController < ApplicationController
before_filter :authenticate, :only => [:mapsearch, :tagsearch]
before_filter :change_project, :only => [:tagsearch]

   def mapsearch
      @title = "Map Search"
   end

   def tagsearch
      @title = "Tag Search"

      if !params[:tagstring].blank? then
         @title = "Tag Search Results"

         search = OsmShadowSearch.new("by_tagstring", params[:tagstring])
         @result = search.execute
      end
   end

private
   
   def change_project
      @user = current_user
      if !params['change_project'].blank? then
         current_user.project_id = params['change_project']
         current_user.save!
      end
   end

end
