require File.dirname(__FILE__) + '/../test_helper'
#require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_require_email_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:email_confirmation => nil)
      assert assigns(:user).errors.on(:email_confirmation)
      assert_response :success
    end
  end
  
  def test_should_sign_up_user_with_activation_code
    create_user
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  def test_should_activate_user
    assert_nil User.authenticate('aaaron', 'test')
    get :activate, :activation_code => users(:aaaron).activation_code
    assert_redirected_to '/session/new'
    assert_not_nil flash[:notice]
    auth_aaaron = User.authenticate('aaaron', 'monkey')
    assert_equal users(:aaaron), auth_aaaron
    assert auth_aaron.enabled?
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end
  
  protected
  
  def create_user(options = {})
    post  :create, 
          :user => { 
            :login => 'qquire', 
            :email => 'quire@example.com',
            :email_confirmation => 'quire@example.com', 
            :password => 'quire69', 
            :password_confirmation => 'quire69',
            :birthdate => Date.new(1981, 9, 11),
            :gender => "Female"
          }.merge(options)
  end
end
