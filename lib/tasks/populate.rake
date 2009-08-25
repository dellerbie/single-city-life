namespace :db do
  
  desc "Erase and fill database"
  task :populate => [:environment, :unpopulate, :populate_dummy_users, :populate_test_users, :populate_messages]
  
  desc "Erases the data in the database"
  task :unpopulate do
    [User, Profile, Message].each(&:delete_all)
  end
  
  desc "Erase and fill database"
  task :populate_dummy_users => :environment do
    require 'populator'
    require 'faker'
    
    User.populate 100 do |user|
      user.login = Faker::Name.name
      user.email = Faker::Internet.email
      user.crypted_password = '712b4c433304d7cbbfba2b584f0771bea5b49ec8'
      user.salt = '97d02adfadc11cd9d6178b1e8bb02120a3b82a20'
      user.activated_at = 5.days.ago..Time.now
      user.enabled = true
      user.birthdate = 30.years.ago..18.years.ago
      user.gender = ["Male", "Female"]
      
      Profile.populate 1 do |profile|
        profile.user_id = user.id
        profile.interested_in = Profile::INTERESTED_IN
        profile.ethnicity = Profile::ETHNICITIES
        profile.body_type = Profile::BODY_TYPES
        profile.best_feature = Profile::BEST_FEATURES
        profile.loves_when = Populator.sentences(1)
        profile.hates_when = Populator.sentences(1)
        profile.turn_ons = Populator.sentences(1)
        profile.turn_offs = Populator.sentences(1)
        profile.msg_me_if = Populator.sentences(1)
        profile.completed = true
      end
    end  
  end
  
  desc "Loads up test private messages"
  task :populate_messages do 
    require 'populator'
    require 'faker'
    
    Message.delete_all
    
    derrick = User.find_by_login('derrick')
    receiver = User.first :conditions => "login != 'derrick'"
    
    Message.populate 20 do |message|
      message.sender_id = derrick.id
      message.receiver_id = receiver.id
      message.subject = Populator.sentences(1)
      message.message = Populator.sentences(3)
      message.read = true
      message.sender_deleted = false
      message.receiver_deleted = false
      
      Message.populate 1 do |reply|
        reply.parent_id = message.id
        reply.sender_id = receiver.id
        reply.receiver_id = derrick.id
        reply.subject = message.subject
        reply.message = Populator.sentences(2)
        reply.read = true
        reply.sender_deleted = false
        reply.receiver_deleted = false
      end
    end    
  end
  
  desc "Load test users"
  task :populate_test_users do |t|
      DATA_DIRECTORY = "#{RAILS_ROOT}/lib/tasks/sample_data"
      TABLES = %w(users profiles)
      USER_IDS = 1000
    
      class_name = nil  # Use nil to get Rails to figure out the class name
      TABLES.each do |table_name|
        fixture = Fixtures.new(ActiveRecord::Base.connection,
                               table_name, 
                               class_name, 
                               File.join(DATA_DIRECTORY, table_name.to_s))
        fixture.insert_fixtures
        puts "Loaded data from #{table_name}.yml"
      end
  end
end