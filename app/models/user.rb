class User < ActiveRecord::Base
  concerned_with :authentication
  has_one :profile, :dependent => :destroy
  
  def to_param
    self.login
  end
  
  # Returns a user's age
  def age
    return if birthdate.nil?
    today = Date.today
    
    if (today.month > birthdate.month) or (today.month == birthdate.month and today.day >= birthdate.day)   
      # Birthday has already happened this year   
      today.year - birthdate.year
    else
      today.year - birthdate.year - 1
    end
  end
  
  def interested_sex
    
  end  
end
