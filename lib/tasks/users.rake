namespace :users do
  desc "add authorization token to all users"
  task add_token: :environment do

    User.find_each do |user|
      user.generate_authorization_token
    end
  end
end
