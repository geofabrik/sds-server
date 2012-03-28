module OsmShadowXmlConverter

   require 'xml/libxml'

   def to_xml_node
      node = XML::Node.new 'osm_shadow'
      node['osm_id'] = self.osm_id.to_s
      node['osm_type'] = self.osm_type

      self.tags.each do |tag|
         tnode = XML::Node.new 'tag'
         tnode['k'] = tag.key
         tnode['v'] = tag.value
         node << tnode
      end

      return node
   end

   def self.from_xml(xml)
      collection = Array.new
      p = XML::Parser.string(xml)
      doc = p.parse

      doc.find('//osm_sds/osm_shadow').each do |s|
         shadow = OsmShadow.new({'osm_id' => s['osm_id'], 'osm_type' => s['osm_type']})

         s.find('tag').each do |t|
            tag = Tag.new({'key' => t['k'], 'value' => t['v']})
            shadow.tags << tag
         end
         collection.push(shadow)
      end
      return collection
   end

   def self.get_xml_doc
      doc = XML::Document.new
      doc.encoding = XML::Encoding::UTF_8
      root = XML::Node.new 'osm_sds'
      doc.root = root
      return doc
   end

end
