lock '~> 3.19.1'

set :application, 'memos-backend'
set :repo_url, 'git@bitbucket.org:tfg-workspace/memos-backend.git'
set :branch, 'deploy-to-prod'

set :deploy_to, '/var/www/tfg-api.ddns.net'

append :linked_files, 'config/database.yml', 'config/master.key', 'config/secrets.yml', 'config/credentials/production.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

set :rvm_type, :user
set :rvm_ruby_version, '3.1.2'
set :rvm_custom_path, '/usr/share/rvm'

set :pty, true
set :keep_releases, 5
