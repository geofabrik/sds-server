require 'spec_helper'

describe "LayoutLinks" do

   it "should have a Sign-in page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Sign in")
   end

   describe "when not signed in" do
      it "should have a signin link" do
         visit root_path
         response.should have_selector("a", :href => signin_path, :content => "Sign in")
      end
   end

   describe "when signed in" do
      before(:each) do
         @user = Factory(:user)
         visit signin_path
         fill_in :email,    :with => @user.email
         fill_in :password, :with => @user.password
         click_button
      end

      it "should have a signout link" do
         visit root_path
         response.should have_selector("a", :href => signout_path, :content => "Sign out")
      end

      it "should have a search link" do 
         visit home_path
         response.should have_selector("a", :href => mapsearch_path, :content => "Search")
      end
  end

   describe "when signed in as admin" do
      before(:each) do
         @user = Factory(:user)
         @user.toggle!(:admin)
         visit signin_path
         fill_in :email,    :with => @user.email
         fill_in :password, :with => @user.password
         click_button
      end

      it "should have a users link" do
         visit home_path
         response.should have_selector("a", :href => users_path, :content => "Users")
      end
  end


end
