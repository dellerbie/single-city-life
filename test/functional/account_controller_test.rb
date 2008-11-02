require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  fixtures :users
  
  def setup
    @quentin = users(:quentin)
  end
  
  def test_should_change_password_and_redirect_to_edit_page
    login_as :quentin
    post :update_password, {:user => {:old_password => 'monkey', :password => '111111', :password_confirmation => '111111'}}
    assert_not_nil assigns(:user)
    assert_response :redirect
    assert_equal "Password successfully updated.", flash[:notice]
  end
  
  def test_should_not_change_password
    login_as :quentin
    post :update_password, {:user => {:old_password => 'abc123', :password => '111111', :password_confirmation => '111111'}}
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template 'edit'
    assert_nil flash[:notice]
  end
  
end