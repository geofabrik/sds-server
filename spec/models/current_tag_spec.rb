require 'spec_helper'

describe CurrentTag do

   before(:each) do 
      @current_osm_shadow = Factory(:current_osm_shadow)
      @attr = {
         :key => "number",
         :value => "123",
      }
   end


   it "should create a new instance given valid attributes" do
      @current_osm_shadow.tags.create!(@attr)
      @current_osm_shadow.tags.each do |t|
         t.id.should be_a_kind_of(Numeric)
      end
   end


   it "should require a key" do
      @current_osm_shadow.tags.create!(@attr).should be_valid
      @current_osm_shadow.tags.build(@attr.merge(:key => nil)).should_not be_valid
      @current_osm_shadow.tags.new(@attr.merge(:key => nil)).should_not be_valid
   end

   it "should require a current_osm_shadow_id" do
      CurrentTag.new(@attr).should_not be_valid
   end

end
