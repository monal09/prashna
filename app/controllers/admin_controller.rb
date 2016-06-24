class AdminController < ApplicationController

  include CheckAdmin
  before_action :authenticate
  before_action :admin_privelage_required

  def index
  end

end
