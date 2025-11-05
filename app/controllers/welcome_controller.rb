class WelcomeController < ApplicationController
	include ApplicationHelper, SessionsHelper, UsersHelper

  def index
  end

  def dashboard
  	if current_user.present?
  		role = current_user.role
  		if role.name == 'SPA' or role.name == 'System Administrator'
			@projects = Project.where("project_end_date >= ?", Date.today)
			@archived_projects = Project.where("project_end_date < ?", Date.today)
			@pending_rpprs = Rppr.where(status: 2)
			@archived_rpprs = Rppr.where(status: 4)
  		elsif role.name == 'Project PI'
  			@projects = current_user.projects
			  @dms_todos = Rppr.where(status: [1, 3], project_id: @projects.map(&:id)).select{|r| r.current?}
  			@data_repositories = current_user.data_repositories
  		elsif role.name == 'PI Delegate'
  			@projects = []
  			@data_repositories = []
  			current_user.delegate_pis.each do |pi|
  				@projects += pi.projects
  				@data_repositories += pi.data_repositories
  			end
  		end
	else
		flash[:alert] = "Please login before register the project"
		redirect_to root_path
  	end
  end

  def ut_cloud
  end

  def public_cloud
  end
end
