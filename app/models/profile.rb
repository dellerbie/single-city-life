class Profile < ActiveRecord::Base
  belongs_to :user
  
  INTERESTED_IN = ["Men", "Women", "Both"]
  ETHNICITIES = [ "African-American", "White", "Asian", "Indian", "Pacific Islander", "Hispanic", "Carribbean", "Native American"].sort!
  BODY_TYPES = ["Thin", "Fit", "Athletic", "Little Extra", "Big", "Petite", "Curvy"].sort!
  BEST_FEATURES = ["Smile", "Face", "Hair", "Stomache", "Legs", "Personality", "Butt", "Chest"].sort!
  STRING_FIELDS = %w(loves_when hates_when turn_ons turn_offs msg_me_if)
  MAX_STRING_LENGTH = 255
  
  validates_presence_of   [:interested_in, :ethnicity, :body_type, :best_feature, :thinks, :my_kinda, STRING_FIELDS]
  
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
 
  validates_length_of     [:thinks, :my_kinda, STRING_FIELDS],
                          :maximum => MAX_STRING_LENGTH
                      
end
