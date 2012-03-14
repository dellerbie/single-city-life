require "smtp_tls"

ActionMailer::Base.raise_delivery_errors = true  
ActionMailer::Base.delivery_method = :smtp  
ActionMailer::Base.smtp_settings = {  
  :address  => "smtp.gmail.com",  
  :port  => 587,   
  :domain => 'mykeepr.com',  
  :user_name  => "derrick@mykeepr.com",  
  :password  => "mauisun6",  
  :authentication  => :plain  
} 