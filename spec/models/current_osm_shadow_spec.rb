require 'spec_helper'

describe CurrentOsmShadow do
   
   before(:each) do
      @attr = {
         :osm_id => 123,
         :osm_type => "way",
         :changeset_id => 2,
         :version => 3   
      }
   end

   it "should create a new instance given valid attributes" do
      shadow = CurrentOsmShadow.new(@attr)
      shadow.save!
      shadow.id.should be_a_kind_of(Numeric)
   end

   describe "validations" do

      it "should have a osm_type" do
         CurrentOsmShadow.new(@attr).should be_valid
         CurrentOsmShadow.new(@attr.merge(:osm_type => nil)).should_not be_valid
      end

      it "should have a osm_id" do
         CurrentOsmShadow.new(@attr).should be_valid
         CurrentOsmShadow.new(@attr.merge(:osm_id => nil)).should_not be_valid
      end

      it "should have a version" do
         CurrentOsmShadow.new(@attr).should be_valid
         CurrentOsmShadow.new(@attr.merge(:version => nil)).should_not be_valid
      end

      it "should have a changeset" do
         CurrentOsmShadow.new(@attr).should be_valid
         CurrentOsmShadow.new(@attr.merge(:changeset_id => nil)).should_not be_valid
      end

      it "should have a numeric osm_id" do
         shadow = CurrentOsmShadow.new(@attr.merge(:osm_id => "abc"))
         shadow.should_not be_valid
      end 

      it "should have a numeric changeset_id" do
         shadow = CurrentOsmShadow.new(@attr.merge(:changeset_id => "abc"))
         shadow.should_not be_valid
      end 

      it "should have a numeric version" do
         shadow = CurrentOsmShadow.new(@attr.merge(:version => "abc"))
         shadow.should_not be_valid
      end

      it "should reject duplicate combinations of osm_id and osm_type" do
         CurrentOsmShadow.create!(@attr)
         shadow = CurrentOsmShadow.new(@attr)
         shadow.should_not be_valid
      end

      it "should accept different combinations of osm_id and osm_type" do
         CurrentOsmShadow.create!(@attr)
         shadow = CurrentOsmShadow.new(@attr.merge(:osm_id => 222, :osm_type => "relation"))
         shadow.should be_valid
      end

   end

   describe "associations" do
      before(:each) do
         @current_osm_shadow = CurrentOsmShadow.create(@attr)
         @t1 = Factory(:current_tag, :current_osm_shadow => @current_osm_shadow)
         @t2 = Factory(:current_tag, :current_osm_shadow => @current_osm_shadow)
      end

      it "should have a tags association" do
         @current_osm_shadow.should respond_to(:tags)
      end

      it "should destroy associated tags" do
         @current_osm_shadow.destroy
         [@t1, @t2].each do |t|
            CurrentTag.find_by_id(t.id).should be_nil
         end
      end

      it "should destroy associated tags with destroy_all" do
         CurrentOsmShadow.destroy_all({:osm_type => @current_osm_shadow.osm_type, :osm_id => @current_osm_shadow.osm_id})
         [@t1, @t2].each do |t|
            CurrentTag.find_by_id(t.id).should be_nil
         end
      end

   end


   it "should be the newest version from osm_shadow"
   it "should contain the same values as the corresponding osm_shadow"
   it "should not make a current-entry if there are no tags"

end
