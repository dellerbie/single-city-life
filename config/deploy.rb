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



namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

role :app, domain
role :web, domain
role :db, domain, :primary => true