require 'spec_helper'

describe HomeController do
   render_views

      describe "GET 'status'" do

         describe "as not-signed-in user" do
            it "should redirect to sign-in page" do
               get 'status'
               response.should redirect_to(signin_path)
            end
         end

         describe "as a signed in non-admin user" do
            before(:each) do
               user = Factory(:user, :email => "aaaa@geofabrik.de")
               test_sign_in(user)
            end
            it "should redirect to home page" do
               get 'status'
               response.should redirect_to(home_path)
            end
         end

         describe "as a signed in admin user" do
            before(:each) do
               user = Factory(:user, :email => "aaaa@geofabrik.de")
               user.toggle(:admin)
               test_sign_in(user)
            end
            it "should be successful" do
               get 'status'
               response.should be_success
            end


            it "should show the number of objects in database" do
               get 'status'
               response.should have_selector("h2", :content => "Database Statistics")
            end
            it "should show the admins" do
               get 'status'
               response.should have_selector("h2", :content => "Application Admins")
            end
            it "should show the last 5 changesets in database" do
               get 'status'
               response.should have_selector("h2", :content => "Last Edits in Database")
            end
         end
      end


      describe "GET 'index'" do
         describe "as not-signed-in user" do 
            it "should redirect to sign-in page" do
               get 'index'
               response.should redirect_to(signin_path)
            end

         end

         describe "as a signed in user" do
            before(:each) do
               user = Factory(:user, :email => "aaaa@geofabrik.de")
               test_sign_in(user)
            end

            it "should be successful" do
               get 'index'
               response.should be_success
            end

            it "should have the right title" do
               get 'index'
               response.should have_selector("title", :content => "HOT Separate OSM Data Store")
            end

            it "should have the right title" do
               get 'index'
               response.should have_selector("title", :content => "Home")
            end

            it "should have the favicon" do
               get 'index'
               response.should have_selector("link", :href => "/assets/layout/favicon.ico")
            end

            it "should have a sign out link" do
               get 'index'
               response.should have_selector("a", :content => "Sign out")
            end

            it "should have the hot link" do
               get 'index'
               response.should have_selector("a", :content => "HOT")
            end

            it "should have the right h1" do
               get 'index'
               response.should have_selector("h1", :content => "HOT Data Store")
            end

            it "should have the logo" do
               get 'index'
               response.should have_selector("img", :src => "/assets/layout/logo.png")
            end
         end

      end
end
