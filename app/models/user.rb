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
  
  def default_photo(size=:thumb)
    photo = self.photos.find_by_id(self.default_photo_id)
    if photo
      photo = photo.public_filename(size)
    else
      photo = BLANK_PHOTO
    end
  end
  
  def reassign_default_photo
    new_default_photo = self.photos.first
    self.default_photo_id = new_default_photo ? new_default_photo.id : nil
    self.save!
  end
  
  protected
  
  def make_profile
    profile = Profile.new
    profile.user = self
    profile.save_with_validation(false)
  end
end
