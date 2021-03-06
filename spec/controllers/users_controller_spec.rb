require 'spec_helper'

describe UsersController do
	integrate_views
	
	describe "GET 'new'" do
		it "should be successful" do
			get 'new'
			response.should be_success
		end
		
		it "should have the right title" do
			get 'new'
			response.should have_tag("title", /Sign Up/)
		end
	end
	
	describe "Get 'show'" do
		before(:each) do
			@user = Factory(:user)
			User.stub!(:find, @user.id).and_return(@user)
		end
		
		it "should be successful" do
			get :show, :id => @user
			response.should be_success
		end
		
		it "should have the right title" do
			get :show, :id => @user
			response.should have_tag("title", /#{@user.name}/)
		end

		it "should have the user's name" do
			get :show, :id => @user
			response.should have_tag("h2",/#{@user.name}/)
		end

		it "should have a profile image" do
			get :show, :id => @user
			response.should have_tag("h2>img", :class => "gravatar")
		end
	end
	
	describe "POST 'create'" do
		describe "failure" do
			it "should render the 'new' page" do
				post :create, :user => {}
				response.should render_template('new')
			end
			
			it "should have the right titlle" do
				post :create, :user => {}
				response.should have_tag("title", /sign up/i)
			end
		end
		
		describe "success" do
			before(:each) do
				@attr = { :name => "New User", :email => "user@example.com",
					:password => "foobar", :password_confirmation => "foobar" }
				@user = Factory.build(:user, @attr)
				User.stub!(:new).and_return(@user)
			end
			
			it "should save the new user" do
				@user.should_receive(:save).and_return(true)
				post :create, :user => @attr
			end
			
			it "should redirect to the user show page" do
				post :create, :user => @attr
				response.should redirect_to(user_url(@user))
			end
			
			it "should have a welcome message" do
				post :create, :user => @attr
				flash[:success].should =~ /welcome to the sample app/i
			end

			it "should sign the user in" do
			  post :create, :user => @attr
			  controller.should be_signed_in
	  end
		end
	end
	
end
