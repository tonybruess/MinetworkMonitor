require "bundler/capistrano"
require "rvm/capistrano"
load "deploy/assets"

set :rvm_ruby_string, "ruby-1.9.3-p194"
set :rvm_type, :user
set :rvm_path, "$HOME/.rvm"
set :rvm_bin_path, "$HOME/.rvm/bin"

set :application, "minetwork"
set :repository, "git@github.com:mrapple/MinetworkMonitor.git"

set :scm, :git
set :branch, 'master'
set :deploy_to, "/home/deploy/apps/minetwork"
set :user, 'deploy'
set :port, 50210

server 'dal02.oc.tc', :app, :db, :web, :primary => true

default_environment["RAILS_ENV"] = 'production'

set :rails_env, :production

ssh_options[:forward_agent] = true

#require 'capistrano-unicorn'
#after "deploy:restart", "unicorn:restart"
