require 'spec_helper'

describe User do

   before(:each) do 
      @attr = {
         :firstname  => "Christine",
         :lastname   => "Karch",
         :email      => "karch@geofabrik.de",
         :password   => "blubber"
      }
   end

   it "should require a firstname" do
      no_name_user = User.new(@attr.merge(:firstname => ""))
      no_name_user.should_not be_valid
   end

   it "should require a lastname" do
      no_name_user = User.new(@attr.merge(:lastname => ""))
      no_name_user.should_not be_valid
   end

   it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
   end

   it "should reject firstnames that are too long" do
      long_name = "a" * 65
      long_name_user = User.new(@attr.merge(:firstname => long_name))
      long_name_user.should_not be_valid
   end

   it "should reject lastnames that are too long" do
      long_name = "a" * 65
      long_name_user = User.new(@attr.merge(:lastname => long_name))
      long_name_user.should_not be_valid
   end

   it "should accept valid email addresses" do
      addresses = %w[user@geofabrik.de THE_USER@geofabrik.de first.last@geofabrik.de]
      addresses.each do |address|
         valid_email_user = User.new(@attr.merge(:email => address))
         valid_email_user.should be_valid
      end
   end

   it "should reject invalid email addresses" do
      addresses = %w[foo@geofabrik,de user_at_geofabrik.de first.last@geofabrik.]
      addresses.each do |address|
         invalid_email_user = User.new(@attr.merge(:email => address))
            invalid_email_user.should_not be_valid
      end
   end

   it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
   end

   it "should reject email addresses identical to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicated_email = User.new(@attr)
      user_with_duplicated_email.should_not be_valid
   end

   it "should accept valid active values" do
      blub_user = User.new(@attr.merge(:active => false))
      blub_user.should be_valid
   end

   it "should reject invalid active values" do
      blub_user = User.new(@attr.merge(:active => nil))
      blub_user.should_not be_valid
   end

   describe "admin attribute" do
      before(:each) do
         @user = User.create!(@attr)
      end

      it "should respond to admin" do
         @user.should respond_to(:admin)
      end

      it "should not be an admin by default" do
         @user.should_not be_admin
      end

      it "should be convertible to an admin" do
         @user.toggle!(:admin)
         @user.should be_admin
      end

   end


   describe "project_id attribute" do
      before(:each) do
         @user = User.create!(@attr)
      end

      it "should have a default project id" do
         @user.project_id.is_a?(Numeric).should be_true
      end

      it "should be accessible" do
         pid0 = @user.project_id
         @user.project_id = pid0 +1
         @user.save!
         @user.reload
         @user.project_id.should_not == pid0
      end

   end


end
