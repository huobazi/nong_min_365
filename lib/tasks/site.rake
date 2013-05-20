# encoding: utf-8
namespace :site do
  desc 'Backup...'
  task :backup => [:environment] do
    sh 'backup perform -t nm365_backup --config_file config/backup/config.rb --log-path log --tmp-path tmp'
  end
end
