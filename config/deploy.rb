require "bundler/capistrano"
require "rvm/capistrano"
load "deploy/assets"

set :rvm_ruby_string, "ruby-1.9.3-p194"
set :rvm_type, :user
set :rvm_path, "$HOME/.rvm"
set :rvm_bin_path, "$HOME/.rvm/bin"

set :application, "minetworkmonitor"
set :repository, "git@github.com:mrapple/MinetworkMonitor.org.git"

set :scm, :git
set :branch, 'master'
set :deploy_to, "/home/deploy/apps/minetwormonitor"
set :user, 'deploy'
set :port, 50210

server 'dal02.oc.tc', :app, :db, :web, :primary => true

default_environment["RAILS_ENV"] = 'production'

set :rails_env, :production

ssh_options[:forward_agent] = true

namespace :deploy do
    namespace :assets do
        task :precompile, :roles => :web, :except => { :no_release => true } do
            from = source.next_revision(current_revision)
            if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
                run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
            else
                logger.info "Skipping asset pre-compilation because there were no asset changes"
            end
        end
    end
end

require 'capistrano-unicorn'
after "deploy:restart", "unicorn:restart"
