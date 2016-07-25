def login_user(user)
  session[:user_id] = user.id
  @current_user = user
end

def build_attributes(*args)
  FactoryGirl.build(*args).attributes.delete_if do |k, v| 
    ["id", "created_at", "updated_at"].member?(k)
  end
end