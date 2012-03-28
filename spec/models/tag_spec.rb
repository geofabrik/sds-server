require 'spec_helper'

describe Tag do

   before(:each) do
      @osm_shadow = Factory(:osm_shadow)
      @attr = {:key => "hot_key", :value => "hot_value"}
   end

   it "should create a new instance given valid attributes" do
      @osm_shadow.tags.create!(@attr)
   end

   describe "osm_shadow associations" do
      before(:each) do
         @tag = @osm_shadow.tags.create(@attr)
      end

      it "should have an osm_shadow attribute" do
         @tag.should respond_to(:osm_shadow)
      end

      it "should have the right associated osm_shadow" do
         @tag.osm_shadow_id.should == @osm_shadow.id
         @tag.osm_shadow.should == @osm_shadow
      end
   end

   describe "tag associations" do
      it "should have a osm_shadow attribute" do
         @osm_shadow.should respond_to(:tags)
      end
   end

   describe "validations" do

      it "should require a osm_shadow id" do
         Tag.new(@attr).should_not be_valid
      end
   end

end
