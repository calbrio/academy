module AdminAuthorization
  extend ActiveSupport::Concern
  
  included do
    before_action :require_admin
    
    private
    
    def require_admin
      unless current_user&.admin?
        flash[:alert] = "You are not authorized to access this page."
        redirect_to root_path
      end
    end
  end
end