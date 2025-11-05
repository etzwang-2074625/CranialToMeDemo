class DataRepositoriesController < ApplicationController
  include ApplicationHelper, SessionsHelper, UsersHelper
  before_action :set_user
  before_action :authorize_user!
  before_action :set_data_repository, except: [:new, :create]

  def new
    @data_repository = DataRepository.new
  end

  def create
    @data_repository = DataRepository.new
    @data_repository.user = @user
    @data_repository.name = data_repository_params[:name]
    @data_repository.description = data_repository_params[:description]
    @data_repository.repository_url = data_repository_params[:repository_url]
    # @data_repository.dr_type = data_repository_params[:dr_type]

    begin
      @data_repository.save!
      ActionLog.create(user_id: current_user.id, subject_id: @data_repository.id, subject_type: @data_repository.class.name, data: @data_repository.saved_changes)
      respond_to do |format|
        format.html do
          flash[:success] = "Data Repository successfully created."
          redirect_to welcome_dashboard_path and return
        end
        format.js do
          flash[:notice] = "Data Repository successfully created."
          @data_repository_record = DataRepositoryRecord.new()
          @rppr_id = data_repository_params[:rppr_id]
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Error: #{e.message}"
      respond_to do |format|
        format.html { redirect_to new_user_data_repository_path(current_user) }
        format.js { render 'message' }
      end
    end
  end

  def edit
  end

  def update
    @data_repository.name = data_repository_params[:name]
    @data_repository.description = data_repository_params[:description]
    @data_repository.repository_url = data_repository_params[:repository_url]
    # @data_repository.dr_type = data_repository_params[:dr_type]
    begin
      @data_repository.save!
      ActionLog.create(user_id: current_user.id, subject_id: @data_repository.id, subject_type: @data_repository.class.name, data: @data_repository.saved_changes)
      flash[:success] = "Data Repository successfully updated."
      respond_to do |format|
        format.html { redirect_to welcome_dashboard_path }
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Error: #{e.message}"
      respond_to do |format|
        format.html { redirect_to edit_user_data_repository_path(current_user, @data_repository) }
      end
    end
  end

  def destroy
    if !@data_repository.data_repository_records.empty?
      flash[:alert] = "Can not delete the data repository when there are existing data repository records in progress report"
      redirect_to welcome_dashboard_path and return
    end

    @data_repository.destroy
    ActionLog.create(user_id: current_user.id, subject_id: @data_repository.id, subject_type: @data_repository.class.name, data: { destroyed: @data_repository.attributes })
    flash[:success] = "Data repository removed."
    redirect_to welcome_dashboard_path and return
  end

  private

  def data_repository_params
    @data_repository_params ||= params.require(:data_repository).permit(:name, :description, :repository_url, :dr_type, :rppr_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_user!
    unless @user == current_user
      redirect_to root_path, alert: "You are not authorized to access this resource."
      return
    end
  end

  def set_data_repository
    @data_repository = @user.data_repositories.where(id: params[:id]).first

    if @data_repository.nil?
      redirect_to root_path, alert: "You are not authorized to access this resource."
      return
    end
  end
end
