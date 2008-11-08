require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase  
  fixtures :users

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    user = create_user
    user.reload
    assert_not_nil user.activation_code
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_require_birthdate
    assert_no_difference 'User.count' do
      u = create_user(:birthdate => nil)
      assert u.errors.on(:birthdate)
    end
  end

  def test_should_require_gender
    assert_no_difference 'User.count' do
      u = create_user(:gender => nil)
      assert u.errors.on(:gender)
    end
  end

  def test_should_require_zipcode
    assert_no_difference 'User.count' do
      u = create_user(:zipcode => nil)
      assert u.errors.on(:zipcode)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_not_change_password
    u = create_user
    u.changing_password(true)
    params = {:user => {:old_password => 'abc123', :password => '111111', :password_confirmation => '111111'}}
    u.change_password(params)
    assert !u.valid?
    assert u.errors.on(:old_password)
  end

  def test_should_change_password
    u = create_user
    u.changing_password(true)
    params = {:user => {:old_password => u.password, :password => '111111', :password_confirmation => '111111'}}
    u.change_password(params)
    assert u.valid?
  end
  
  def test_should_be_correct_password
    u = create_user
    assert u.correct_password?(u.password)
  end
  
  def test_should_not_be_correct_password
    u = create_user
    assert !u.correct_password?('abc123')
  end
  
  def test_should_not_change_email
    u = create_user
    params = {:user => {:email => '', :email_confirmation => ''}}
    u.change_email(params)
    assert !u.valid?
    assert u.errors.on(:email)
  end
  
  def test_should_change_email
    u = create_user
    params = {:user => {:email => 'quire@e.com', :email_confirmation => 'quire@e.com'}}
    u.change_email(params)
    assert u.valid?
  end
  
  def test_should_deactivate

  end

  protected
  def create_user(options = {})
    record = User.new({ :login => 'qquire',
      :email => 'quire@example.com',
      :email_confirmation => 'quire@example.com',
      :password => 'quire69',
      :password_confirmation => 'quire69',
      :birthdate => Date.new(1981, 9, 11),
      :gender => "Female",
    :zipcode => "90210" }.merge(options))
    record.save
    record
  end
end
