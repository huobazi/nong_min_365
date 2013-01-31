# -*- encoding : utf-8 -*-
# Ubuntu 12.04 LTS 
namespace :env do
  task :production => [:environment] do
    set :domain,              'nongmin365.com'
    set :deploy_to,           "/home/deployer/app/#{app}"
    set :sudoer,              'deployer'
    set :user,                'deployer'
    set :group,               'deployer'
    set :rvm_path,            '/usr/local/rvm/scripts/rvm'
    set :services_path,       '/etc/init.d'          # Where your God and Unicorn service control scripts will go
    set :nginx_path,          '/etc/nginx'
    set :deploy_server,       'linodeweb01'                   # just a handy name of the server
    set :rvm_string,          '1.9.3'

    invoke :defaults                                         # load rest of the config
    invoke :"rvm:use[#{rvm_string}]"
  end
end
