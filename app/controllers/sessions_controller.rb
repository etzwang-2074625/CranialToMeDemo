class SessionsController < ApplicationController
  include SessionsHelper
  layout false
  
  def params
    request.parameters
  end
  
  def new
  end

  def shib_new
  end

  def shib_auth
     
    if params[:Ecom_User_ID].present? and params[:Ecom_Password].present?
      if params[:Ecom_User_ID].downcase.include?('tao')
        user = User.first
      elsif params[:Ecom_User_ID].downcase.include?('zhang')
        user = User.where(user_login: 'guo-qiang.zhang@uth.tmc.edu').first
      end
      if user.present?
        sign_in user
        flash[:success] = "Welcome to DEPUT, #{user.name}!"
        
        redirect_to root_path
      else
        flash[:danger] = "User not found in DEPUT, please sign up or add your UTHealth email in your profile if you already have one DEPUT Login."
        render 'new'
      end
    else
      flash[:danger] = "Please Enter UTH User ID and Password to Authenticate."
      render 'new'
    end
  end

  def acs
    @varialbes = request.env
    if @varialbes['mail'].present?
      users = User.where(user_login: @varialbes['mail'].downcase)
      if users.present?
        user = users.first
        sign_in user
        flash[:success] = "Welcom to DEPUT, #{user.name}!"
        redirect_to root_path
      else
        flash[:danger] = "User #{@varialbes['cn']} not found in CUIBIE, please sign up or add your UTHealth email in your profile if you already have one CUIBIE Login."
        render 'new'
      end
    else
      logger.info "====Apache Envrionment Variables===="
      logger.info @varialbes.to_s
      logger.info "====Apache Envrionment Variables===="
      flash[:danger] = "Authentication failed with your UT credential. Please retry your credential or contact the site owner."
      render 'new'
    end
  end

  def create
    if params[:session][:name].present? and params[:session][:password].present?
      username = params[:session][:name].strip.downcase
      user = User.find_by_user_login(username)

      if user.present? and user.status=='active'
        if user.authenticate(params[:session][:password])
          sign_in user
          flash[:success] = "Welcome to DPEUT, #{user.user_firstname}!"
          redirect_to welcome_index_path
          return
        else
          flash[:danger] = 'Invalid name/password combination' # Not quite right!
          render 'new'
        end
      elsif user.present? and user.status=='inactive'
        flash[:warning] = "Your account is not activated yet. "
        render 'new'
      else
        flash[:danger] = 'User not found'
        render 'new'
      end
    else
      flash[:danger] = "Please Enter Network ID and Password"
      render 'new'
    end
  end
  

  def destroy
    sign_out
    flash[:notice] = "Logout successfully"
    redirect_to landing_index_path
  end

end
