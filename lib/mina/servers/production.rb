# -*- encoding : utf-8 -*-
# Ubuntu 12.04 LTS 
namespace :env do
  task :production => [:environment] do
    set :domain,              'deploy.nongmin365.com'
    set :deploy_to,           "/home/deployer/app/#{app}"
    set :sudoer,              'deployer'
    set :user,                'deployer'
    set :group,               'deployer'
    set :services_path,       '/etc/init.d'          # Where your God and Unicorn service control scripts will go
    set :nginx_path,          '/etc/nginx'
    set :deploy_server,       'linodeweb01'                   # just a handy name of the server

    invoke :defaults                                         # load rest of the config

    set :rvm_path,            '/usr/local/rvm/scripts/rvm'
    set :rvm_string,          '2.1.5'

    invoke :"rvm:use[#{rvm_string}]"
  end
end
