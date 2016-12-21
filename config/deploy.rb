lock '3.5.0'

set :application, 'consul-legislation'
set :repo_url, 'git@github.com:medialab-prado/consul.git'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/cache')
set :rbenv_type, :user
set :rbenv_ruby, '2.3.2'
set :rbenv_path, '/home/ubuntu/.rbenv'
set :delayed_job_workers, 1

set :passenger_restart_with_touch, true
