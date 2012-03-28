require 'spec_helper'

describe OsmShadowsController do
   render_views

   describe "signed-in user" do
      before(:each) do
         @user = Factory(:user)
         test_sign_in(@user)
      end

      describe "GET 'index'" do
         it "should redirect to tagsearch" do
            get :index
            response.should redirect_to(tagsearch_path)
         end
      end


      describe "GET 'show'" do
         before(:each) do
            @osm_shadow = Factory(:current_osm_shadow)
         end
         it "should be successfull"  do
            get :show, :osm_type => @osm_shadow.osm_type, :osm_id => @osm_shadow.osm_id
            response.should be_success
         end

         it "should have the right title" do
            get :show, :osm_type => @osm_shadow.osm_type, :osm_id => @osm_shadow.osm_id
            response.should have_selector("title", :content => "Object Properties")
         end
      end

      describe "GET 'new'" do

         it "should be successfull" do
            get :new, :osm_type => "way", :osm_id => 123
            response.should be_success
         end

         it "should have the right title" do
            get :new, :osm_type => "way", :osm_id => 123
            response.should have_selector("title", :content => "New Tags")
         end

         it "should save zoom, lat and lon from params" do
            @lat = 11.0
            @lon = 12.0
            @zoom = 13
            get :new, :osm_type => "way", :osm_id => 123, :zoom => @zoom, :lat => @lat, :lon => @lon
            @user.lat.should == @lat
            @user.lon.should == @lon
            @user.zoom.should == @zoom
         end
      end

      describe "GET 'edit'" do
         before(:each) do
            @osm_shadow = Factory(:current_osm_shadow)
         end
         it "should be successfull" do 
            get :edit, :osm_type => @osm_shadow.osm_type, :osm_id => @osm_shadow.osm_id
            response.should be_success
         end

         it "should have the right title" do
            get :edit, :osm_type => @osm_shadow.osm_type, :osm_id => @osm_shadow.osm_id
            response.should have_selector("title", :content => "Edit Tags")
         end
      end
   end



   describe "POST 'create'" do

      describe "success" do
         before(:each) do
            @user = Factory(:user)
            @changeset = Factory(:changeset)
            test_sign_in(@user)

            @attr = {
               :osm_id        => 112,
               :osm_type      => "node",
               :project_id    => 1,
               :changeset_id  => @changeset.id
            }
            @attr_tags = {
               :key           => ["AA", "BB", "CC", "DD"], 
               :value         => ["aa", "bb", "cc", "dd"]
            }   
         end

         it "should redirect to osm_shadow_path" do
            pending("get assigns to right route")
            post :create, :osm_shadow => @attr, :tags => @attr_tags
            response.should redirect_to(osm_shadow_path(assigns(:osm_shadow)))
         end


         it "should create a osm_shadow" do
            lambda do
               post :create, :osm_shadow => @attr, :tags => @attr_tags
            end.should change(OsmShadow, :count).by(1)
         end

         it "should create tags" do
            lambda do
               post :create, :osm_shadow => @attr, :tags => @attr_tags
            end.should change(Tag, :count).by(4)
         end

         it "should create osm_shadow without tags" do
            pending("get assigns to right route")
            post :create, :osm_shadow => @attr, :tags => {:key => [], :value => []}
            response.should redirect_to(osm_shadow_path(assigns(:osm_shadow)))
         end

         it "should create all tags if no unselected_value parameter is given" do
            @unselected = 'unselected'
            lambda do
               post :create, :osm_shadow => @attr, :taghash => {'aa' => 'blub', 'bb' => @unselected} 
            end.should change(Tag, :count).by(2)
         end

         it "should not create a tag with value 'unselected' if unselected_value parameter is given" do
            @unselected = 'unselected'
            lambda do
               post :create, :osm_shadow => @attr, :taghash => {'aa' => 'blub', 'bb' => @unselected}, :unselected_value => @unselected
            end.should change(Tag, :count).by(1)
         end
      end

   end

   describe "inactive user" do
      before(:each) do
         @osm_shadow = Factory(:current_osm_shadow)
         @user = Factory(:user, :active => false)
         #test_sign_in(@user)
      end

      describe "GET 'edit'" do
         it "should redirect to signin" do
            get :edit, :osm_type => @osm_shadow.osm_type, :osm_id => @osm_shadow.osm_id
            response.should redirect_to(signin_path)
         end
      end
   end

end
