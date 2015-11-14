module SessionsHelper
  def current_admin
    begin
      @current_admin ||= Admin.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    rescue ActiveRecord::RecordNotFound => e
      @current_admin = nil
    end
  end

  def generate_remember_token(admin)
      admin.update_attribute(:auth_token, SecureRandom.urlsafe_base64)
  end
end
