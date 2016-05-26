namespace :admin do
  desc "create a new admin"
  task new: :environment do

    user = User.new
    puts "Enter first name"
    user.first_name = STDIN.gets.chomp

    puts "Enter last name"
    user.last_name = STDIN.gets.chomp

    puts "Enter email"
    user.email = STDIN.gets.chomp

    puts "Enter password"
    user.password = STDIN.gets.chomp

    user.admin = true
    user.verify!

    if user.save
      puts "Admin user successfully created"
    else
      puts "Failed to create admin user"
      user.errors.full_messages.each do |msg|
        p msg
      end
    end

  end

end
