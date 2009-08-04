RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/app/middleware )
  config.time_zone = 'Eastern Time (US & Canada)'
  
  config.action_controller.session_store = :active_record_store
  config.action_controller.session = {
    :session_key => '_singles_session',
    :secret      => 'fccec3abfd7b95b61e6e35ce5b761d92481118679b8d0490db5120735cef1f3d1b670276c7c46d713d592034662bb07685a494fede9e1b9b97d949be2b8521eb'
  }
  
  config.active_record.observers = :user_observer
  
  APP_NAME = "Singles"
  DB_STRING_MAX_LENGTH = 255
  DB_TEXT_MAX_LENGTH = 40000
  HTML_TEXT_FIELD_SIZE = 20
  TEXT_ROWS = 10
  TEXT_COLS = 40
  MAX_PHOTOS = 20
  BLANK_PHOTO = "/images/default-user-110-90.jpg"
  
  ENV['RECAPTCHA_PUBLIC_KEY'] = "6LdhiwcAAAAAAOmlgzZuAaktWl6HGwB2gZwEhxaN"
  ENV['RECAPTCHA_PRIVATE_KEY'] = "6LdhiwcAAAAAAPLXvhOPgfzq6Ys8k3gJy6-1jTu5"
end