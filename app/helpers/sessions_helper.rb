module SessionsHelper
	def sign_in(user)
    cookies.permanent[:remember_token] = user.id # user.remember_token
    current_user = user

    if current_user.admin?
      session[:admin] = 1
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
  	current_user = nil
    cookies.delete(:remember_token)
    cookies.delete(:project_id)
    cookies.delete(:project_name)
    cookies.delete(:role_id)
    cookies.delete(:role_name)
  end

  def ldap_authentication?
    false
  end

end
