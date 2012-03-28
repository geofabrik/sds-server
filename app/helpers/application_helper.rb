module ApplicationHelper

   def new_shadow_path(otype, oid)
      return "#{osm_shadows_path}/new/#{otype}/#{oid}"
   end

   def edit_shadow_path(otype, oid)
      return "#{osm_shadows_path}/edit/#{otype}/#{oid}"
   end

   def show_shadow_path(otype, oid)
      return "#{osm_shadows_path}/show/#{otype}/#{oid}"
   end

end
