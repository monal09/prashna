class CreditsController < ApplicationController
  
  before_action :authenticate, only: [:new, :show]
  
  def new
    @credits = Credit.all
  end

end
