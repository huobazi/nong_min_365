# -*- encoding : utf-8 -*-
set :use_sudo, false

# RVM
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3-p327-falcon'
set :rvm_type, :user

set :application, "nongmin365.com"
set :domain, "nongmin365.com"
set :repository,  "git@bitbucket.org:huobazi/nong_min_365.git"
set :scm, :git 
set :scm_verbose, true
set :branch, "master"
set :user,        ""
set :password,    ""
set :deploy_to,   "/home/#{user}/#{application}"

default_run_options[:pty] = true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# unicorn.rb 路径
set :unicorn_path, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid_path, "#{deploy_to}/current/tmp/pids/unicorn.pid"
namespace :deploy do

  desc "Start Application"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  end

  desc "Stop Application"
  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid_path}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{unicorn_pid_path}`"
  end

  task :init_shared_path, :roles => :web do
    run "mkdir -p #{shared_path}/config"
  end
  
  desc "things I need to do after deploy:setup"
  task :setup_config, :roles => :app do
    run "#{try_sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "#{try_sudo} ln -nfs #{current_path}/script/unicorn.sh /etc/init.d/unicorn_#{application}"
    run "#{try_sudo} update-rc.d unicorn_#{application} default"
    
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "Now you should edit the config files in #{shared_path} and create the database"
  end
  after "deploy:setup", "deploy:init_shared_path","deploy:setup_config"

  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end

#task :compile_assets, :roles => :web do
#run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:precompile"
#end


