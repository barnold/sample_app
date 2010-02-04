require 'spec_helper'

describe PagesController do
integrate_views

	before(:each) do
		@base_title = "Ruby on Rails Tutorial Sample App | "
	end

  describe "GET 'home'" do
  	before(:each) { get 'home' }
  		
    it "should be successful" do
      response.should be_success
    end
    
    it "should have the right title" do
    	response.should have_tag("title", @base_title + "Home")
    end
    
    it "should have screen stylesheet" do
    	response.should have_tag("link[media='screen']")
    	response.should have_tag("link[media='print']")
	end
	
	it "should have a logo" do
		response.should have_tag("img", :alt => "Sample App Logo")
	end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
    	get 'contact'
    	response.should have_tag("title", @base_title + "Contact")
    end
  end
  
  describe "GET 'about'" do
  	it "should be successful" do
  		get 'about'
  		response.should be_success
  	end

    it "should have the right title" do
    	get 'about'
    	response.should have_tag("title", @base_title + "About")
    end
  end	
  
  describe "GET 'help'" do
  	it "should be successful" do
  		get 'help'
  		response.should  be_success
  	end
  	
    it "should have the right title" do
    	get 'help'
    	response.should have_tag("title", @base_title + "Help")
    end
  end
end
