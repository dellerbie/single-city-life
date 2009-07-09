require 'digest/sha1'

class User
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  VALID_GENDERS = ["Male", "Female"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  VALID_AGES = (18..100).to_a

  validates_presence_of     :login
  validates_uniqueness_of   :login
  validates_length_of       :login,    
                            :within => 6..15
                            
  validates_format_of       :login,    
                            :with => Authentication.login_regex, 
                            :message => Authentication.bad_login_message

  validates_presence_of     :email
  validates_length_of       :email,    
                            :within => 6..100
                            
  validates_uniqueness_of   :email
  validates_confirmation_of :email
  validates_format_of       :email,    
                            :with => Authentication.email_regex, 
                            :message => Authentication.bad_email_message
                            
  validates_presence_of     :gender
  validates_inclusion_of    :gender,
                            :in => VALID_GENDERS,
                            :allow_nil => false,
                            :message => "must be Male or Female"

  validates_presence_of     :birthdate
  validates_inclusion_of    :birthdate,
                            :in => VALID_DATES,
                            :allow_nil => true,
                            :message => "is invalid"

  validates_presence_of     :old_password, :if => :changing_password?
  validates_each            :old_password,
                            :if => :changing_password? do |model, attr, value|
                              model.errors.add(:old_password, 'does not match current password') unless model.correct_password?(value)
                            end

  before_create             :make_activation_code
  
  attr_accessor             :old_password
  
  attr_accessible           :login, :email, :email_confirmation, :password,
                            :password_confirmation, :old_password, :gender,
                            :birthdate, :enabled

  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def recently_activated?
    @activated
  end

  def active?
    activation_code.nil?
  end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end

  def correct_password?(password)
    self.crypted_password == encrypt(password)
  end

  def changing_password?
    @changing_password
  end

  def changing_password(changing)
    @changing_password = changing
  end

  def change_password(params)
    changing_password(true)
    self.old_password = params[:user][:old_password]
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
  end

  def change_email(params)
    self.email = params[:user][:email]
    self.email_confirmation = params[:user][:email_confirmation]
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def password_required?
    crypted_password.blank? || !password.blank? || changing_password?
  end

  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end

  protected

  def make_activation_code
    self.activation_code = self.class.make_token
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
