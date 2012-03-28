require 'spec_helper'

describe "Users" do

   describe "new user" do
      before(:each) do
         user = Factory(:user)
         user.toggle!(:admin)
         visit signin_path
         fill_in :email,    :with => user.email
         fill_in :password, :with => user.password
         click_button
      end

      describe "failure" do
         it "should not make a new user" do
            lambda do
               visit new_user_path
               fill_in "Lastname",  :with => ""
               fill_in "Firstname", :with => ""
               fill_in "Email",     :with => ""
               click_button
               response.should render_template('users/new')
               response.should have_selector("div#error_explanation")
            end.should_not change(User, :count)
         end
      end

      describe "success" do
         it "should make a new user" do
            lambda do
               visit new_user_path
               fill_in "Lastname",  :with => "Christine"
               fill_in "Firstname", :with => "Karch"
               fill_in "Email",     :with => "karch@geofabrik.de"
               click_button
               response.should have_selector("div.flash.success", :content => "successfully")
               response.should render_template('users/show')
            end.should change(User, :count).by(1)
         end
      end
   end

   describe "sign in/out" do

      describe "failure" do
         it "should not sign a user in" do
            visit signin_path
            fill_in :email,    :with => ""
            fill_in :password, :with => ""
            click_button
            response.should have_selector("div.flash.error", :content => "Invalid")
         end
      end

      describe "success" do
         it "should sign a user in and out" do
            user = Factory(:user)
            visit signin_path
            fill_in :email,    :with => user.email
            fill_in :password, :with => user.password
            click_button
            controller.should be_signed_in
            click_link "Sign out"
            controller.should_not be_signed_in
         end
      end
   end 


end
