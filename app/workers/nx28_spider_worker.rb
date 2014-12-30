class Nx28SpiderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, :queue => 'spider', :backtrace => true

  def perform
    ::Nx28Spider.new.run_spider
  end

end

