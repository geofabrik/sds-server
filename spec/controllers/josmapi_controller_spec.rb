require 'spec_helper'

describe JosmapiController do


   describe "GET 'collectshadows'" do
      before(:each) do
         @shadow = Factory(:current_osm_shadow)
         @t1 = Factory(:current_tag, :current_osm_shadow => @shadow, :value => "cat")
         @t2 = Factory(:current_tag, :current_osm_shadow => @shadow, :value => "dog")
      end

      describe "success" do
         before(:each) do
            @user = Factory(:user)
            @credentials = ActionController::HttpAuthentication::Basic.encode_credentials @user.email, @user.password
         end

         it "should find the right action" do
            request.env['HTTP_AUTHORIZATION'] = @credentials
            get :collectshadows, :ways => '123,333' ,:relations => '444' 
            response.should be_success
         end
      end

      describe "failure" do
         it "should deny access to unauthorized users" do
            get :collectshadows, :ways => '123,333' ,:relations => '444' 
            response.should_not be_success
         end

         it "should send status 401" do
            get :collectshadows, :ways => '123,333' ,:relations => '444' 
            response.code.should eq("401")
         end
      end

   end

   describe "POST 'collectshadows'" do
      before(:each) do
         @shadow = Factory(:current_osm_shadow)
         @t1 = Factory(:current_tag, :current_osm_shadow => @shadow, :value => "cat")
         @t2 = Factory(:current_tag, :current_osm_shadow => @shadow, :value => "dog")
      end
     
      describe "success" do
         before(:each) do
            @user = Factory(:user)
            @credentials = ActionController::HttpAuthentication::Basic.encode_credentials @user.email, @user.password
         end

         it "should find the right action" do
            request.env['HTTP_AUTHORIZATION'] = @credentials
            post :collectshadows, { :ways => '123,333', :relations => '444'}
            response.should be_success
         end
         
      end

   end


   describe "POST 'createshadows'" do

      describe "success" do
         before(:each) do
            @user = Factory(:user)
            @credentials = ActionController::HttpAuthentication::Basic.encode_credentials @user.email, @user.password
            @xml = '<xml><osm_sds><osm_shadow osm_id="123" osm_type="way"><tag k="abc" v="schnee"/></osm_shadow></osm_sds></xml>'
         end

         it "should find the right action" do
            request.stub!(:raw_post).and_return(@xml)
            request.env['HTTP_AUTHORIZATION'] = @credentials
            post :createshadows
            response.should be_success
         end

         it "should find the param" do
            request.stub!(:raw_post).and_return(@xml)
            request.env['HTTP_AUTHORIZATION'] = @credentials
            post :createshadows
            request.raw_post.to_s.should == @xml
         end

         it "should create a changeset" do
            lambda do
               request.stub!(:raw_post).and_return(@xml)
               request.env['HTTP_AUTHORIZATION'] = @credentials
               post :createshadows
            end.should change(Changeset, :count).by(1)
         end

         it "should create a osm_shadow (check without lambda)" do
            cnt = OsmShadow.where("osm_id = ? and osm_type = ?", 123, "way").count

            request.stub!(:raw_post).and_return(@xml)
            request.env['HTTP_AUTHORIZATION'] = @credentials
            post :createshadows

            cnt2 = OsmShadow.where("osm_id = ? and osm_type = ?", 123, "way").count
            diff = cnt2 - cnt 
            diff.should == 1
         end

         it "should create a osm_shadow (check with lambda)" do
            lambda do
               request.stub!(:raw_post).and_return(@xml)
               request.env['HTTP_AUTHORIZATION'] = @credentials
               post :createshadows
            end.should change(OsmShadow, :count).by(1)
         end

         it "should create a tag" do
            lambda do
               request.stub!(:raw_post).and_return(@xml)
               request.env['HTTP_AUTHORIZATION'] = @credentials
               post :createshadows
            end.should change(Tag, :count).by(1)
         end
      end

      describe "failure" do
         it "should deny access to unauthorized users" do
            xml = '<xml><osm_sds><osm_shadow osm_id="123" osm_type="way"><tag k="abc" v="schnee"/></osm_shadow></osm_sds></xml>'
            request.stub!(:raw_post).and_return(xml)
            post :createshadows
            response.should_not be_success
         end
      end
   end

end
