# Provide tasks to load and delete sample user data.
require 'active_record'
require 'active_record/fixtures'

namespace :db do
  DATA_DIRECTORY = "#{RAILS_ROOT}/lib/tasks/sample_data"
  namespace :sample_data do
    TABLES = %w(users profiles)
    
    # Starting id for the sample data
    USER_IDS = 1000
    
    desc "Load sample data"
    task :load => :environment do |t|
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
    
    desc "Remove sample data"
    task :delete => :environment do |t|
      Profile.delete_all("id > #{USER_IDS}")
      User.delete_all("id > #{USER_IDS}")
    end
  end
end