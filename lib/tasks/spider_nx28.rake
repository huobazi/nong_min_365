# -*- encoding : utf-8 -*-
namespace :spider do
  desc 'Crawl nx28 items'
  task :nx28 => :environment do
    ::Nx28Spider.new.run_spider
  end
end
