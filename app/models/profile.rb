class Profile < ActiveRecord::Base
  belongs_to :user
  
  before_create :mark_incomplete
  before_update :mark_complete
  
  INTERESTED_IN = ["Men", "Women", "Both"]
  ETHNICITIES = [ "African-American", "White", "Asian", "Indian", "Pacific Islander", "Hispanic", "Carribbean", "Native American"].sort!
  BODY_TYPES = ["Thin", "Petite", "Athletic", "Curvy", "Little Extra", "Big"]
  BEST_FEATURES = ["Smile", "Face", "Hair", "Stomach", "Legs", "Personality", "Butt", "Chest"].sort!
  STRING_FIELDS = %w(loves_when hates_when turn_ons turn_offs msg_me_if)
  MAX_STRING_LENGTH = 150
  
  validates_presence_of   [:interested_in, :ethnicity, :body_type, :best_feature, STRING_FIELDS]
  
  validates_length_of     [STRING_FIELDS],
                          :maximum => MAX_STRING_LENGTH
  
  validates_inclusion_of  :interested_in,
                          :in => INTERESTED_IN,
                          :allow_nil => false
                          
  validates_inclusion_of  :ethnicity,
                          :in => ETHNICITIES,
                          :allow_nil => false
      
  validates_inclusion_of  :body_type,
                          :in => BODY_TYPES,
                          :allow_nil => false
      
  validates_inclusion_of  :best_feature,
                          :in => BEST_FEATURES,
                          :allow_nil => false
  
  protected
  
  def mark_incomplete
    self.completed = false
    return true   # in order to not break the callback chain
  end
  
  def mark_complete
    self.completed = true
  end
  
end
