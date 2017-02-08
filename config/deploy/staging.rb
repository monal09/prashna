server '35.164.153.206', user: 'monal', roles: [:web, :app, :db], primary: true
set :deploy_to, '/var/www/staging'
set :rails_env, 'staging'
set :branch, 'master'
set :enable_ss, false
after 'deploy', 'deploy:migrate'