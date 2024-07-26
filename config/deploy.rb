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

# Puma settings
set :puma_threads, [4, 16]
set :puma_workers, 0

set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  task :restart do
    invoke 'puma:restart'
  end
end

after 'deploy:publishing', 'deploy:restart'
