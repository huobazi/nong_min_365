# -*- encoding : utf-8 -*-
namespace :apt do
  desc "Ex: cap apt:install -s name=vim"
  task :install do
    queue echo_cmd "sudo apt-get -y install #{fetch(:name)}"
  end

  desc "Run the apt-get update and upgrade, Ex: cap apt:upgrade"
  task :upgrade do
    queue echo_cmd "sudo apt-get update"
    queue echo_cmd "sudo apt-get -y upgrade"
    #queue echo_cmd "sudo apt-get -y dist-upgrade"
  end
end

namespace :spider do
  desc "Run the Nx28 spider"
  task :nx28 do
    queue echo_cmd "cd #{deploy_to}/#{current_path}; RAILS_ENV=production bundle exec rake spider:nx28"
  end
end

namespace :cache do
  desc "Clear the application cache"
  task :clear  do
    queue echo_cmd "cd #{deploy_to}/#{current_path}; RAILS_ENV=production bundle exec rake cache:clear"
  end
end

namespace :backup do
  desc "Backup the web and database"
  task :default do
    #web
    db
  end

  desc "Backup the web"
  task :web do
    db
  end

  desc "Backup the database"
  task :db do
    queue echo_cmd "cd #{deploy_to}/#{current_path}; RAILS_ENV=#{rails_env} bundle exec rake site:backup"
  end
end

namespace :remote_rake do
  desc "Run a task on remote servers, ex: cap remote_rake:invoke task=cache:clear" 
  task :invoke do
    queue echo_cmd "cd #{deploy_to}/#{current_path}; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['task']}"
  end
end
