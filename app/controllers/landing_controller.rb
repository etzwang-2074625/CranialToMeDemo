class LandingController < ApplicationController
  include ApplicationHelper, SessionsHelper
  layout 'landing'

  def params
  end 


  def index
    if !request.referer
      return 
    end
    if !request.referer.include?(welcome_index_path)
      return 
    end 

    if current_user.present? && !request.referer.include?(welcome_index_path)
      redirect_to welcome_index_path
    end
  end 
end 