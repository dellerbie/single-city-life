default_run_options[:pty] = true

set :application, "singles"
set :user, "derrick"
set :domain, "dellerbie.com"
set :port, 15280
set :repository,  "ssh://#{user}@#{domain}:15280/home/#{user}/git/#{application}.git"
set :scm, "git"
set :branch, "master"
set :deploy_to, "/home/#{user}/rails/#{application}"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :use_sudo, false
set :git_enable_submodules, 1
set :rails_env, "production"
set :db_user, "singles"
set :db_password, "mauisun6"
set :db_backups_path, "/var/backups/singles/db"
set :db_name, "#{application}_#{rails_env}"
set :photos_backups_path, "/var/backups/singles/photos"

role :app, domain
role :web, domain
role :db, domain, :primary => true

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc 'Creates a symlink to the shared photos directory.'
task :symlink_photos do
  run "mkdir -p #{shared_path}/photos; ln -s #{shared_path}/photos #{current_path}/public/photos"
end

desc 'Tails the production log.'
task :watch_log do
  stream("tail -f #{current_path}/log/production.log")
end

desc 'Populates database with dummy data'
task :populate_db do
  run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:populate && RAILS_ENV=#{rails_env} rake db:sample_data:load"
end

desc 'Clears out outdated sessions > 12.hours.ago'
task :clear_stale_sessions do 
  run <<-EOC
    cd #{current_path} && ./script/runner -e #{rails_env} 'ActiveRecord::SessionStore::Session.delete_all(["updated_at < ?", 30.seconds.ago])'
  EOC
end

desc 'Clears all sessions from the database' 
task :clear_sessions do
  run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:sessions:clear"
end

namespace :backups do
  desc 'Backup photos and database'
  task :default do 
    db
    photos
  end
  
  desc 'Backs up the photos'
  task :photos do
    filename = "photos_#{Time.now.strftime '%Y%m%dT%:%H%M%S'}.tgz" 
    run "tar -czvf #{photos_backups_path}/#{filename} #{shared_path}/photos"
    get "#{photos_backups_path}/#{filename}", "/Users/derrick/backup/#{filename}"
  end
  
  desc 'Backs up the database'
  task :db, :roles => :db do 
    filename = "#{application}_db_dump.#{Time.now.strftime '%Y%m%dT%:%H%M%S'}.sql" 
    run "mysqldump -u#{db_user} -p#{db_password} #{db_name} > #{db_backups_path}/#{filename}" do |channel, stream, data|
      puts data
    end
    get "#{db_backups_path}/#{filename}", "/Users/derrick/backup/#{filename}"
  end
end

before :deploy, :backups
after "deploy:symlink", :symlink_photos, :clear_sessions