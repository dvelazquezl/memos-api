lock '~> 3.19.1'

set :application, 'memos-backend'
set :repo_url, 'git@bitbucket.org:tfg-workspace/memos-backend.git'

set :deploy_to, '/var/www/tfg-api.ddns.net'

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

set :rvm_type, :user
set :rvm_ruby_version, '3.1.2'

set :pty, true
set :default_env, { path: '~/.rvm/bin:$PATH' }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'puma:restart'
  end
end
