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
  desc "Setting up the shared_path after deploy:setup"
  task :init_shared_path, :roles => :web do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/config/initializers"
  end

  desc "Setting up configs after deploy:setup"
  task :setup_config, :roles => :app do
    run "sudo ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "sudo ln -nfs #{current_path}/script/unicorn.sh /etc/init.d/unicorn_#{application}"
    run "sudo update-rc.d unicorn_#{application} default"

    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "PLEASE edit the #{shared_path}/config/database.yml and create the database"

    put File.read("config/initializers/secret_token.rb.example"), "#{shared_path}/config/initializers/secret_token.rb"
    puts "PLEASE edit and the  #{shared_path}/config/initializers/secret_token.rb"
  end
  after "deploy:setup", "deploy:init_shared_path","deploy:setup_config"

  task :link_app_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{current_path}/config/initializers/secret_token.rb"
  end
  after "deploy:symlink", "deploy:link_app_config" # current 的软连接更新后再更新database.yml软连接

  desc "Start Application"
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  end

  desc "Stop Application"
  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid_path}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{unicorn_pid_path}`"
  end


end

namespace :apt do
  task :install, :roles => :app do
    run "sudo apt-get -y install #{fetch(:name)}"
  end

  task :upgrade, :roles => :app do
    run "sudo apt-get update"
    run "sudo apt-get -y upgrade"
    run "sudo apt-get -y dist-upgrade"
  end
end

namespace :spider do
  task :nx28, :roles => :web do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake spider:nx28"
  end
end

namespace :cache do
  task :clear, roles => :app  do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake cache:clear"
  end
end

namespace :backup do

  task :default do
    web
    db
  end

  task :web, :roles => :web do
    puts "Backing Up Web Server"
  end

  task :db, :roles => :db do
    puts "Backing Up DB Server"
  end

end

