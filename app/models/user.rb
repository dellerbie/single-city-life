class User < ActiveRecord::Base
  concerned_with :authentication
  has_one :profile, :dependent => :destroy
  
  has_many  :sent_messages,
            :class_name => "Message", 
            :foreign_key => :sender_id, 
            :conditions => "sender_deleted = false",
            :order => 'created_at DESC'
                            
  has_many  :received_messages,
            :class_name => "Message", 
            :foreign_key => :receiver_id, 
            :conditions => "receiver_deleted = false",
            :order => 'created_at DESC'
            
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
  
  def self.per_page
    10
  end
  
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
  end
  
  def has_photos?
    n_photos > 0
  end
  
  def n_photos
    self.photos.size
  end
  
  def to_json
    json = {
      :id => self.id,
      :login => self.login,
      :age => self.age,
      :best_feature => self.profile.best_feature,
      :loves_when => self.profile.loves_when,
      :hates_when => self.profile.hates_when,
      :turn_ons => self.profile.turn_ons,
      :turn_offs => self.profile.turn_offs,
      :msg_me_if => self.profile.msg_me_if,
      :default_photo => self.default_photo,
      :has_photos => has_photos?,
      :n_photos => n_photos
    }
  end
  
  def num_unread_messages
    #Message.count :conditions => ["receiver_id = ?", id]
    received_messages.count :conditions => ["messages.read = ?", false]
  end

  protected
  
  def make_profile
    profile = Profile.new
    profile.user = self
    profile.save_with_validation(false)
  end
end
