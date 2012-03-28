require 'spec_helper'

describe "Homepages" do
  describe "GET /home" do


    describe "when not signed in" do
      it "should have a signin link" do
         visit home_path
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


      it "works! (now write some real specs)" do
         # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
         get home_path
         response.status.should be(200)
      end

      it "should have a tag search link" do
         get home_path
         response.should have_selector("li", :content => "Tag search")
      end

      it "should have a map select link" do
         get home_path
         response.should have_selector("li", :content => "Map search")
      end

      it "should display firstname and lastname" do
         get home_path
         response.should have_selector("th", :content => "Name")
      end

      it "should display default object class" do
         get home_path
         response.should have_selector("th", :content => "project")
      end

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
         response.should have_selector("a", :href => users_path, :content => "User administration")
      end

      it "should show admin rights" do
         visit home_path
         response.should have_selector("th", :content => "Admin rights")
      end
   end
end
