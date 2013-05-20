namespace :site do
  desc "Back up the database"
  task :backup do
    sh "backup perform --trigger nm365_backup --config_file config/backup.rb --data-path db --log-path log --tmp-path tmp"
  end
end
