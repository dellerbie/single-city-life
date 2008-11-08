require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  fixtures :users
  
  def setup
    @quentin = users(:quentin)
  end
  
  def test_should_change_password_and_redirect_to_edit_page
    login_as :quentin
    post :update_password, {:user => {:old_password => 'monkey', :password => '111111', :password_confirmation => '111111'}}
    user = assigns(:user)
    assert_not_nil user
    assert_response :redirect
    assert_equal "Password successfully updated.", flash[:notice]
  end
  
  def test_should_not_change_password
    login_as :quentin
    post :update_password, {:user => {:old_password => 'abc123', :password => '111111', :password_confirmation => '111111'}}
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.on(:old_password), "#{user.errors.full_messages.to_sentence}"
    assert_response :success
    assert_template 'edit'
    assert_nil flash[:notice]
  end
  
  def test_should_change_email_and_redirect_to_edit_page
    login_as :quentin
    post :update_email, {:user => {:email => 'test@gmail.com', :email_confirmation => 'test@gmail.com'}}
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.empty?
    assert_response :redirect
    assert_equal "Email successfully updated.", flash[:notice]
  end
  
  def test_should_not_change_email
    login_as :quentin
    post :update_email, {:user => {:email => 'test1@gmail.com', :email_confirmation => 'test@gmail.com'}}
    user = assigns(:user)
    assert_not_nil user
    assert user.errors.on(:email), "#{user.errors.full_messages.to_sentence}"
    assert_response :success
    assert_template 'edit'
    assert_nil flash[:notice]
  end
  
end