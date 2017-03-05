server '35.166.38.58', user: 'prashna_master', roles: [:web, :app, :db], primary: true
set :deploy_to, '/var/www/staging'
set :rails_env, 'staging'
set :branch, 'master'
set :enable_ss, false
after 'deploy', 'deploy:migrate'