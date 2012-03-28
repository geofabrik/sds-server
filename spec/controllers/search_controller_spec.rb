require 'spec_helper'

describe SearchController do
   render_views

   describe "GET 'mapsearch" do
      before(:each) do
         @user = Factory(:user)
      end
      describe "signed-in" do
         it "should be successfull" do
            test_sign_in(@user)
            get :mapsearch
            response.should be_success
         end
      end

      describe "not signed-in" do
         it "should redirect to sign-in" do
            get :mapsearch
            response.should redirect_to(signin_path)
         end
      end
   end

   describe "GET 'tagsearch'" do
      before(:each) do
         @user = Factory(:user)
      end

      describe "signed-in" do
         before(:each) do
            test_sign_in(@user)
         end

         it "should be successfull" do
            get :tagsearch
            response.should be_success
         end

         describe "with search string" do
            it "should be successfull" do 
               get :tagsearch, :tagstring => "blub"
               response.should be_success
            end 

            it "should have a result headline" do
               changeset = Factory(:changeset, :user => @user)
               shadow = Factory(:current_osm_shadow, :changeset => changeset)
               t1 = Factory(:current_tag, :current_osm_shadow => shadow, :value => "blub")
               t2 = Factory(:current_tag, :current_osm_shadow => shadow, :key => "blub")
               get :tagsearch, :tagstring => "current"
               response.should have_selector("h2", :content => "result")
               response.should have_selector("th", :content => "OSM ID")
            end

            it "should have only one result for each shadow object"

         end

      end

      describe "not signed-in" do
         it "should redirect to sign-in" do
            get :tagsearch
            response.should redirect_to(signin_path)
         end
      end
   end

end
