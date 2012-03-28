require 'spec_helper'

describe UsersController do
   render_views


   describe "as a non-signed-in user" do
      before(:each) do
         @user = Factory(:user)
         @attr = {
            :firstname => "ABC",
            :lastname => "EFG",
            :email => "abc@geofabrik.de",
            :password => "abc",
            :active => true
         }
      end

      it "should deny access to (get :index)" do
         get :index
         response.should redirect_to(signin_path)
      end
      it "should deny access (get :show, :id => @user)" do
         get :show, :id => @user
         response.should redirect_to(signin_path)
      end
      it "should deny access (get :new)" do
         get :new
         response.should redirect_to(signin_path)
      end
      it "should deny access (get :edit, :id => @user)" do
         get :edit, :id => @user
         response.should redirect_to(signin_path)
      end
      it "should deny access (post :create, :user => @attr)" do
         post :create, :user => @attr
         response.should redirect_to(signin_path)         
      end
      it "should deny access (put :update, :id => @user, :user => @attr)" do
         put :update, :id => @user, :user => @attr
         response.should redirect_to(signin_path)
      end
   end

   describe "as a signed-in user" do
      before(:each) do
         @user = Factory(:user)
         @attr = {
            :firstname => "ABC",
            :lastname => "EFG",
            :email => "abc@geofabrik.de",
            :password => "abc",
            :active => true
         }
      end

      describe "as a non-admin user" do
         it "should deny access to (get :index)" do
            test_sign_in(@user)
            get :index
            response.should redirect_to(home_path)
         end
         it "should deny access (get :show, :id => @user)" do
            test_sign_in(@user)
            get :show, :id => @user
            response.should redirect_to(home_path)
         end
         it "should deny access (get :new)" do
            test_sign_in(@user)
            get :new
            response.should redirect_to(home_path)
         end
         it "should deny access (get :edit, :id => @user)" do
            test_sign_in(@user)
            get :edit, :id => @user
            response.should redirect_to(home_path)
         end
         it "should deny access (post :create, :user => @attr)" do
            test_sign_in(@user)
            post :create, :user => @attr
            response.should redirect_to(home_path)         
         end
         it "should deny access (put :update, :id => @user, :user => @attr)" do
            test_sign_in(@user)
            put :update, :id => @user, :user => @attr
            response.should redirect_to(home_path)
         end
      end

      describe "as a admin user" do
         before(:each) do
            admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
            test_sign_in(admin)
         end

         it "should be successfull (get :index)" do
            get :index
            response.should be_success
         end
         it "should be successfull (get :show, :id => @user)" do
            get :show, :id => @user
            response.should be_success
         end
         it "should be successfull (get :new)" do
            get :new
            response.should be_success
         end
         it "should be successfull (get :edit, :id => @user)" do
            get :edit, :id => @user
            response.should be_success
         end
         it "should be successfull (post :create, :user => @attr)" do
            post :create, :user => @attr
            response.should redirect_to(user_path(assigns(:user)))
         end
         it "should be successfull (put :update, :id => @user, :user => @attr)" do
            put :update, :id => @user, :user => @attr
            response.should redirect_to(user_path(@user))
         end
      end
   end



   describe "inactive admin" do
      before(:each) do
         @user = Factory(:user)
         @admin_inactive = Factory(:user, :firstname => 'admin', :email => 'xxx@geofabrik.de', :admin => true, :active => false)
      end

      it "should not have access to index" do
         test_sign_in(@admin_inactive)
         get :index
         response.should redirect_to(signin_path)
      end

      it "should not have access to edit user" do
         test_sign_in(@admin_inactive)
         get :edit, :id => @user
         response.should redirect_to(signin_path)
      end
   end




   describe "PUT 'update'" do
      before(:each) do
         @user = Factory(:user)
         admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
         test_sign_in(admin)
      end

      describe "failure" do
         before(:each) do
            @attr = {
               :firstname => "",
               :lastname => "",
               :email => "",
               :password => "",
               :active => ""
            }
         end

         it "should render the 'edit' page" do
            put :update, :id => @user, :user => @attr
            response.should render_template('edit')
         end
         it "should have the right title" do
            put :update, :id => @user, :user => @attr
            response.should have_selector("title", :content => "Edit User")
         end
      end

      describe "success" do
         before(:each) do
            @attr = {
               :firstname => "Christine",
               :lastname => "Karch",
               :email => "foo@geofabrik.de",
               :password => "abc123",
               :active => true
            }
         end
         
         it "should change the users attributes" do
            put :update, :id => @user, :user => @attr
            @user.reload
            @user.lastname.should == @attr[:lastname]
            @user.email.should == @attr[:email]
         end

         it "should redirect to the users show page" do
            put :update, :id => @user, :user => @attr
            response.should redirect_to(user_path(@user))
         end

         it "should have a flash message" do
            put :update, :id => @user, :user => @attr
            flash[:success].should =~ /updated/
         end
      end
   end

   describe "GET 'edit'" do
      before(:each) do
         @user = Factory(:user)
         admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
         test_sign_in(admin)
      end

      it "should be successfull" do
         get :edit, :id => @user
         response.should be_success
      end

      it "should have the right title" do
         get :edit, :id => @user
         response.should have_selector("title", :content => "Edit User")
      end
   end


   describe "GET 'index'" do
      before(:each) do
         admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
         test_sign_in(admin)
         @user = Factory(:user)
         second = Factory(:user, :email => "second@hermione.de")
         third  = Factory(:user, :email => "third@hermione.de")

         @users = [@user, second, third]
         20.times do
            @users << Factory(:user, :email => Factory.next(:email))
         end
      end

      it "should be successful" do
         get :index
         response.should be_success
      end

      it "should have the right title" do
         get :index
         response.should have_selector("title", :content => "All users")
      end

      it "should have an project element for each user" do
         get :index
         @users[0..2].each do |user|
            response.should have_selector("tr", :content => user.project.name)
         end
      end
   end


   describe "GET 'new'" do
      before(:each) do
         admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
         test_sign_in(admin)
      end

      it "should be successful" do
         get 'new'
         response.should be_success
      end

      it "should have the right title" do
         get 'new'
         response.should have_selector("title", :content => "New User")
      end
   end

   describe "POST 'create'" do
      before(:each) do
         admin = Factory(:user, :email => "aaaa@geofabrik.de", :admin => true)
         test_sign_in(admin)
      end

      describe "failure" do
         before(:each) do
            @attr = {
               :firstname => "",
               :lastname => "",
               :email => ""   
            }
         end

         it "should not create a user" do
            lambda do
               post :create, :user => @attr
            end.should_not change(User, :count)
         end
         
         it "should  have the right title" do
            post :create, :user => @attr
            response.should have_selector("title", :content => "New User")
         end

         it "should render the 'new' page" do
            post :create, :user => @attr
            response.should render_template('new')
         end
      end

      describe "success" do
         before(:each) do
            @attr = {
               :firstname => "Christine",
               :lastname => "Karch",
               :email => "karch@geofabrik.de"   
            }
         end
         
         it "should create a user" do
            lambda do
               post :create, :user => @attr
            end.should change(User, :count).by(1)
         end
   
         it "should redirect to the user show page" do
            post :create, :user => @attr
            response.should redirect_to(user_path(assigns(:user)))
         end

         it "should have a success message" do
            post :create, :user => @attr
            flash[:success].should =~ /created new user successfully/i
         end

         it "should set the password" do
            my_user = User.create!(@attr)
            my_user.password.should_not be_blank
         end

         it "should create an active user" do
            my_user = User.create!(@attr)
            my_user.should be_active
         end

      end
   end

end
