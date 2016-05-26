namespace :users do
  desc "create a new admin"
  task add_admin: :environment do

    user = User.new
    puts "Enter first name"
    user.first_name = STDIN.gets.chomp

    puts "Enter last name"
    user.last_name = STDIN.gets.chomp

    puts "Enter email"
    user.email = STDIN.gets.chomp

    puts "Enter password"
    user.password = STDIN.gets.chomp

    user.verified_at = Time.current #FIXME_AB: this should be done in before_create
    user.admin = true

    if user.save
      puts "Admin user successfully created"
      user.verification_token = nil
      user.verification_token_expiry_at = nil
      user.save
    else
      puts "Failed to create admin user"
      puts user.errors.full_messages
    end

  end

end
