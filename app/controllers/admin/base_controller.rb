class Admin::BaseController < ApplicationController

  include CheckAdmin

  layout "admin"
  before_action :admin_privelage_required

end
