# -*- encoding : utf-8 -*-
$:.unshift './lib'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

require 'mina/defaults'
require 'mina/extras'
require 'mina/god'
require 'mina/unicorn'
require 'mina/nginx'
require 'mina/utils'

Dir['lib/mina/servers/*.rb'].each { |f| load f }

###########################################################################
# Common settings for all servers
###########################################################################

set :app,                'nong_min_365'
set :repository,         'https://huobazi@bitbucket.org/huobazi/nong_min_365.git'

set :keep_releases,       9999        #=> I like to keep all my releases
set :default_server,     :production

set :shared_paths, ['config/database.yml', 'config/newrelic.yml', 'config/initializers/secret_token.rb', 'tmp', 'log']

###########################################################################
# Tasks
###########################################################################

set :server, ENV['to'] || default_server
invoke :"env:#{server}"

desc "Deploys the current version to the server."

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile' 

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end
