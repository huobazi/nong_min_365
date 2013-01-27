namespace :cache do
  desc 'Clear cache'
  task :clear => [:environment] do
    ActionController::Base.cache_store.clear
    puts 'The caches was clear.'
  end
end
