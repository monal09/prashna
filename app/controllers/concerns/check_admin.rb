module CheckAdmin
  
  extend ActiveSupport::Concern
  
  private

    def admin_privelage_required
      
      unless current_user.admin?
        flash[:notice] = "You must be admin to access this section"
        redirect_to root_path
      end

    end

end