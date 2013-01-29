# -*- encoding : utf-8 -*-
set :use_sudo, false
set :keep_releases, 10

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
set :deploy_via, :remote_cache
set :user,        ""
set :password,    ""
set :deploy_to,   "/home/#{user}/#{application}"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# unicorn 路径
set :unicorn_path, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid_path, "#{deploy_to}/current/tmp/pids/unicorn.pid"

namespace :deploy do
  desc "Prepare the shared folder"
  task :prepare_shared, :roles => :web do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/config/initializers"
  end

  desc "Setup the config files, such as database.yml, newrelic.yml,secret_token.rb"
  task :setup_config, :roles => :app do
    run "sudo ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "sudo ln -nfs #{current_path}/script/unicorn.sh /etc/init.d/unicorn_#{application}"
    run "sudo update-rc.d unicorn_#{application} default"

    files_hash = {
      "config/database.yml.example"                 => "#{shared_path}/config/database.yml",
      "config/newrelic.yml.example"                 => "#{shared_path}/config/newrelic.yml",
      "config/initializers/secret_token.rb.example" => "#{shared_path}/config/initializers/secret_token.rb",
    }
    files_hash.each do |source, target|
      run "ln -nfs #{source} #{target}"
      put File.read(source), "#{target}"
      puts "PLEASE edit the #{target}"
    end
  end

  desc "Create the new config files link to the latest release version"
  task :link_app_config, :roles => :app do
    link_hash = {
      "#{shared_path}/config/database.yml"                 => "#{release_path}/config/database.yml",
      "#{shared_path}/config/newrelic.yml"                 => "#{release_path}/config/newrelic.yml",
      "#{shared_path}/config/initializers/secret_token.rb" => "#{release_path}/config/initializers/secret_token.rb",
    }
    link_hash.each do |source, target|
      run "ln -nfs #{source} #{target}"
    end
  end

  desc "Start the application"
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  end

  desc "Stop the application"
  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid_path}`"
  end

  desc "Restart the application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{unicorn_pid_path}`"
  end
end

namespace :apt do
  desc "Ex: cap apt:install -s name=vim"
  task :install, :roles => :app do
    run "sudo apt-get -y install #{fetch(:name)}"
  end

  desc "Run the apt-get update and upgrade, Ex: cap apt:upgrade"
  task :upgrade, :roles => :app do
    run "sudo apt-get update"
    run "sudo apt-get -y upgrade"
    run "sudo apt-get -y dist-upgrade"
  end
end

namespace :spider do
  desc "Run the Nx28 spider"
  task :nx28, :roles => :web do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake spider:nx28"
  end
end

namespace :cache do
  desc "Clear the application cache"
  task :clear, roles => :app  do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake cache:clear"
  end
end

namespace :backup do
  desc "Backup the web and database"
  task :default do
    web
    db
  end

  desc "Backup the web"
  task :web, :roles => :web do
    puts "Backing Up Web Server"
  end

  desc "Backup the database"
  task :db, :roles => :db do
    puts "Backing Up DB Server"
  end
end

namespace :remote_rake do
  desc "Run a task on remote servers, ex: cap remote_rake:invoke task=cache:clear"
  task :invoke do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['task']}"
  end
end

## 调度
after "deploy:setup", "deploy:prepare_shared","deploy:setup_config"
after "deploy:finalize_update", "deploy:link_app_config"
