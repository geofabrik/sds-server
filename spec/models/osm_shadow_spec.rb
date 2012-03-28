require 'spec_helper'

describe OsmShadow do


   before(:each) do
      @changeset = Factory(:changeset)
      @attr = {
         :osm_id => 123,
         :osm_type => "node"
      }
   end

   it "should create a new instance given valid attributes" do
      @changeset.osm_shadows.create!(@attr)
   end

   describe "changeset associations" do
      before(:each) do
         @osm_shadow = @changeset.osm_shadows.create(@attr)
      end

      it "should have a changeset attribute" do
         @osm_shadow.should respond_to(:changeset)
      end

      it "should have the right associated changeset" do
         @osm_shadow.changeset_id.should == @changeset.id
         @osm_shadow.changeset.should == @changeset
      end
   end

   describe "osm_shadow associations" do
      before(:each) do
         @os1 = Factory(:osm_shadow, :changeset => @changeset, :created_at => 1.day.ago)
         @os2 = Factory(:osm_shadow, :changeset => @changeset, :created_at => 1.hour.ago)
      end

      it "should have a osm_shadows attribute" do
         @changeset.should respond_to(:osm_shadows)
      end

      it "should have the right osm_shadows in the right order" do
         @changeset.osm_shadows.should == [@os2, @os1] # ordered newest first
      end
   end

   describe "validations" do

      it "should require a changeset id" do
         OsmShadow.new(@attr).should_not be_valid
         OsmShadow.new(@attr.merge(:changeset_id => 1)).should be_valid
      end

      it "should require an osm_id" do
         @changeset.osm_shadows.build(@attr).should be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_id => nil)).should_not be_valid
      end

      it "should have an numeric osm_id" do
         @changeset.osm_shadows.build(@attr.merge(:osm_id => 333)).should be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_id => "foo")).should_not be_valid
      end

      it "should have a valid osm_type (node, way or relation)" do
         @changeset.osm_shadows.build(@attr.merge(:osm_type => "node")).should be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_type => "way")).should be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_type => "relation")).should be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_type => "foo")).should_not be_valid
         @changeset.osm_shadows.build(@attr.merge(:osm_type => nil)).should_not be_valid
      end

      it "should require a version before save" do
         os3 = Factory(:osm_shadow, :changeset => @changeset)
         os3.save!
         os3.version.should_not be_nil
         os3.version.should be_a_kind_of(Numeric)
      end

      it "should have an unique combination of oms_id, oms_type and version" do
         os4 = @changeset.osm_shadows.create(@attr.merge(:osm_type => "way", :oms_id => "345"))
         os5 = @changeset.osm_shadows.create(@attr.merge(:osm_type => "way", :oms_id => "345"))
         os4.version.should_not == os5.version

         OsmShadow.where("osm_id = ? and osm_type = ? and version = ?", os4.osm_id, os4.osm_type, os4.version).count("id").should == 1
         OsmShadow.where("osm_id = ? and osm_type = ? and version = ?", os4.osm_id, os4.osm_type, os5.version).count("id").should == 1
         OsmShadow.where("osm_id = ? and osm_type = ?", os4.osm_id, os4.osm_type).count("id").should == 2
      end

   end

   it "should generate a valid version" do
         shadow = @changeset.osm_shadows.new(@attr)
         shadow.save
         shadow.save
         shadow.save
         shadow.version.should == 1
         shadow2 = @changeset.osm_shadows.new(@attr)
         shadow2.save
         shadow2.version.should == 2
         shadow3 = @changeset.osm_shadows.new({'osm_id' => 555, 'osm_type' => 'way'})
         shadow3.save
         shadow3.version.should == 1
   end

   it "should generate a valid version using save_with_current" do
      shadow  = @changeset.osm_shadows.new({:osm_id => 345, :osm_type => 'way'})
      shadow2 = @changeset.osm_shadows.new({:osm_id => 345, :osm_type => 'node'})
      shadow3 = @changeset.osm_shadows.new({:osm_id => 345, :osm_type => 'relation'})
      shadow4 = @changeset.osm_shadows.new({:osm_id => 111, :osm_type => 'way'})

      shadow.save_with_current
      shadow2.save_with_current
      shadow3.save_with_current
      shadow4.save_with_current

      cnt = OsmShadow.where("osm_id = ? and osm_type = ?", shadow.osm_id, shadow.osm_type).count
      cnt.should == 1

      OsmShadow.where("osm_id = ? and osm_type = ?", shadow.osm_id, shadow.osm_type).each do |s|
         s.version.should == 1
      end
   end

   
   it "should generate a valid versions higher than 1" do
      @my_osm_id = 345
      @my_osm_type = "relation"

      my_changeset = Factory(:changeset)
      shadow = OsmShadow.new({:osm_id => @my_osm_id, :osm_type => @my_osm_type})
      shadow.changeset = my_changeset
      shadow.save_with_current

      my_changeset2 = Factory(:changeset)
      shadow2 = OsmShadow.new({:osm_id => @my_osm_id, :osm_type => @my_osm_type})
      shadow2.changeset = my_changeset2
      shadow2.save_with_current

      cnt = OsmShadow.where("osm_id = ? and osm_type = ?", shadow.osm_id, shadow.osm_type).count
      cnt.should == 2

      # default_scope :order => 'osm_shadows.created_at DESC' # newest first
      OsmShadow.where("osm_id = ? and osm_type = ?", shadow.osm_id, shadow.osm_type).first do |s|
         s.version  == 2
      end
   end



   it "should find osm_shadow object from current tables" do
      shadow  = @changeset.osm_shadows.new({:osm_id => 345, :osm_type => 'way'})
      shadow.tags << Tag.new({ :key => "name", :value => "blub"})
      shadow.save_with_current
      blub = OsmShadow.find_current("way", 345)
      blub.should be_a_kind_of(CurrentOsmShadow)
   end

end
