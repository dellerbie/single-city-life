class User < ActiveRecord::Base
  concerned_with :authentication
  has_one :profile, :dependent => :destroy
  has_many :photos, :dependent => :destroy do
    def to_json_for_gallery
      json = {}
      json[:photos] = self.collect do |photo|
        photo.to_json_for_gallery
      end
      json
    end
    
    def maxed?
      self.size >= MAX_PHOTOS
    end
  end
  
  after_create :make_profile
  
  def to_param
    self.login
  end
  
  def age
    return if birthdate.nil?
    today = Date.today
    if (today.month > birthdate.month) or (today.month == birthdate.month and today.day >= birthdate.day)   
      today.year - birthdate.year
    else
      today.year - birthdate.year - 1
    end
  end
  
  protected
  
  def make_profile
    profile = Profile.new
    profile.user = self
    profile.save_with_validation(false)
  end
end
