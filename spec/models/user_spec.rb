# == Schema Information
# Schema version: 20100205154424
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

require 'spec_helper'

describe User do
	before(:each) do
	@attrs = {
	  :name => "value for name",
	  :email => "user@example.com",
	  :password => "foobar",
	  :password_confirmation => "foobar",
	}
	end
	
	it "should create a new instance given valid attributes" do
	User.create!(@attrs)
	end
	
	it "should require a name" do
		no_name_user = User.new( @attrs.merge(:name => "") )
		no_name_user.should_not be_valid
		end
		
	it "should rject names that are too long" do
		long_name = "a" * 51
		long_name_user = User.new( @attrs.merge(:name => long_name) )
		long_name_user.should_not be_valid
	end
	
	it "should accept valid email address" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			valid_email_user = User.new( @attrs.merge(:email => address))
			valid_email_user.should be_valid
		end
	end
	
	it "should reject invalid email addresses" do
	addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
	addresses.each do |address|
	  invalid_email_user = User.new(@attrs.merge(:email => address))
	  invalid_email_user.should_not be_valid
	end
	end
	
	it "should reject duplicate email addresses" do
		User.create!(@attrs)
		user_with_duplicate_email = User.new(@attrs)
		user_with_duplicate_email.should_not be_valid
	end
	
	it "should reject email addresses identical up to case" do
	upcased_email = @attrs[:email].upcase
	User.create!(@attrs.merge(:email => upcased_email))
	user_with_duplicate_email = User.new(@attrs)
	user_with_duplicate_email.should_not be_valid
	end
	
	describe "password validations" do
		it "should require a password" do
			User.new(@attrs.merge(:password => "")).should_not be_valid
		end
		
		it "should require a matching password confirmation" do
			User.new(@attrs.merge(:password_confirmation => "invalid")).
			should_not be_valid
		end
		
		it "should reject short passwords" do
			short = "a" * 5
			hash = @attrs.merge(:password => short, :password_confirmation => short)
			User.new(hash).should_not be_valid
		end
		
		it "should reject long passwords" do
			long = "a" * 41
			hash = @attrs.merge(:password => long, :password_confirmation => long)
			User.new(hash).should_not be_valid
		end		
	end
	
	describe "password encryption" do
		before(:each) { @user = User.create!(@attrs) }
	
		it "should have an encrypted password attribute" do
			@user.should respond_to :encrypted_password
		end
		
		it "should set the encrupted password" do
			@user.encrypted_password.should_not be_empty
		end
		
		describe "has_password? method" do
			it "should be true if the passwords match" do
				@user.has_password?(@attrs[:password]).should be_true
			end
			
			it "should be failse if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end
		end
		
		describe "authenticate method" do
			it "should return nil on email/password mismatch" do
				wrong_password_user = User.authenticate(@attrs[:email], "wrongpass")			
				wrong_password_user.should be_nil
			end
			
			it "should return nil for an email address with no user" do
				nonexistent_user = User.authenticate("bar@foo.com", @attrs[:password])
				nonexistent_user.should be_nil
			end
			
			it "should return the user on email/password match" do
				matching_user = User.authenticate(@attrs[:email], @attrs[:password])
				matching_user.should == @user
			end
		end
	end
end
