require 'spec_helper'

describe Changeset do

   before(:each) do
      @user = Factory(:user)
      @attr = {}
   end

   it "should create a new instance given valid attributes" do
      @user.changesets.create!(@attr)
   end

   describe "user associations" do
      before(:each) do
         @changeset = @user.changesets.create(@attr)
      end

      it "should have a user attribute" do
         @changeset.should respond_to(:user)
      end

      it "should have the right associated user" do
         @changeset.user_id.should == @user.id
         @changeset.user.should == @user
      end
   end

   describe "changeset associations" do
      before(:each) do
         @cs1 = Factory(:changeset, :user => @user, :created_at => 1.day.ago)
         @cs2 = Factory(:changeset, :user => @user, :created_at => 1.hour.ago)
      end

      it "should have a changeset attribute" do
         @user.should respond_to(:changesets)
      end

      it "should have the right changesets in the right order" do
         @user.changesets.should == [@cs2, @cs1] # ordered newest first
      end
   end

   describe "validations" do
      
      it "should require a user id" do
         Changeset.new(@attr).should_not be_valid
      end
   end


# XXX move tests to OsmShadow
#   describe "changeset from xml" do
#      before(:each) do
#         @xml = '<xml><osm_sds><osm_shadow osm_id="123" osm_type="katze"><tag k="abc" v="schnee"/></osm_shadow></osm_sds></xml>'
#      end
#
#      it "should generate a changeset" do
#         cs = Changeset.from_xml(@xml);
#      end
#
#
#      it "should generate a changeset with 0..n osm_shadow objects"
#      it "should generate 0..n tags for each osm_shadow object"
#
#
#   end

end
