class UsersController < ApplicationController
  include ApplicationHelper, SessionsHelper, UsersHelper
  before_action :set_user, only: %i[ show edit update destroy ]

  def params
    request.parameters
  end

  def submit_rppr
    @rppr = Rppr.where(id: params[:rppr_id]).first
    if @rppr.present?
      #update rppr
      @rppr.status = 2
      assign_rppr_attributes if params[:edit].present?
      if @rppr.save
        ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)
        flash[:success] = "DMS progress report sumitted successfully."

        respond_to do |format|
          format.js { render js: 'window.top.location.reload(true);' }
          format.html { redirect_to welcome_dashboard_path }
        end
      else
        flash[:danger] = "Errors prevented DMS progress report from submitting: #{@rppr.errors.full_messages.to_sentence}"
        redirect_to welcome_dashboard_path and return
      end
    else
      flash[:warning] = "DMS progress report not found. Please refresh your page to continue."
      redirect_to welcome_dashboard_path and return
    end
  end

  # GET /users or /users.json
  def add_pi_delegate
    delegate_user = User.where(user_login: params[:delegate_email].strip.downcase).first
    unless delegate_user.present?
      delegate_user = User.new(user_firstname: params[:first_name], user_lastname: params[:last_name], email: params[:delegate_email])
      delegate_user.password = "Deput_#{Time.now.to_i}"
      delegate_user.password_confirmation = "Deput_#{Time.now.to_i}"
      delegate_user.save
    end
    Delegation.where(project_pi_id: current_user.id, pi_delegate_id: delegate_user.id, status: 'active').first_or_create
    redirect_to user_path(current_user)
  end

  def new_rppr
    @project = Project.where(id: params[:project_id]).first
  end
  
  def create_rppr
    @rppr = Rppr.new
    assign_rppr_attributes
    if @rppr.save
      ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)
      flash[:success] = "DMS progress report successfully created."
      redirect_to welcome_dashboard_path
      return
    else
      p @rppr.errors
      flash[:alert] = "Error creating progress report! #{@rppr.errors.full_messages.to_sentence}"
    end

    redirect_to welcome_dashboard_path
  end

  def edit_rppr
    @rppr = Rppr.where(id: params[:rppr_id]).first
    @project = @rppr.project
    @root_comments = @rppr.root_comments
    @all_comments = @rppr.comment_threads
  end

  def update_rppr
    @rppr = Rppr.where(id: params[:rppr_id]).first

    if @rppr.non_edittable?
      flash[:alert] = "Can not edit progress report after submission!"
      redirect_to edit_rppr_user_path(id: current_user.id, rppr_id: @rppr.id)
      return
    end

    assign_rppr_attributes
    if @rppr.save
      ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)
      flash[:success] = "DMS progress report successfully updated."
      redirect_to welcome_dashboard_path
      return
    else
      p @rppr.errors
      flash[:alert] = "Error updating progress report! #{@rppr.errors.full_messages.to_sentence}"
      redirect_to edit_rppr_user_path(id: current_user.id, rppr_id: @rppr.id) and return
    end
  end

  def remove_rppr
    @rppr = Rppr.where(id: params[:rppr_id]).first

    if @rppr.archived?
      flash[:alert] = "Can not remove progress report after approval!"
      redirect_to welcome_dashboard_path
      return
    end

    @rppr.destroy
    flash[:success] = "DMS progress report removed."
    redirect_to welcome_dashboard_path
  end
  

  def index
    @users = User.all.paginate(page: params[:page], per_page: 50)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        if params[:role_ids].present?
          @user.roles = []
          params[:role_ids].each do |role_id|
            role = Role.where(id: role_id)
            @user.roles << role if role.present?
          end
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(params[:user])
        if params[:role_ids].present?
          @user.roles = []
          params[:role_ids].each do |role_id|
            role = Role.find(role_id)
            @user.roles << role if role.present?
          end
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_firstname, :user_lastname, :email, :user_middlename, :institution, :degree, :password, :password_confirmation)
    end

    def assign_rppr_attributes
      @rppr.project_id = params[:project_id] if params[:project_id].present?
      @rppr.start_date = Date.parse(params[:start_date]) if params[:start_date].present?
      @rppr.end_date = Date.parse(params[:end_date]) if params[:end_date].present?
      @rppr.due_date = Date.parse(params[:due_date]) if params[:due_date].present?
      @rppr.year_start = @rppr.start_date.year if @rppr.start_date.present?
      @rppr.year_end = @rppr.end_date.year if @rppr.end_date.present?
      @rppr.data_repository_id = params[:data_repository_id]
      @rppr.supplemental_info = params[:supplemental_info]
      @rppr.data_repository_na = ActiveRecord::Type::Boolean.new.cast(params[:data_repository_na])
      @rppr.data_change = params[:data_change]

      if @rppr.data_repository_na
        @rppr.data_repository_record_ids = []
        @rppr.abstract = ""
      else
        @rppr.data_repository_record_ids = params[:data_repository_record_ids]
        @rppr.abstract = params[:abstract]
      end
      @rppr.data_change_description = (@rppr.data_change ? params[:data_change_description] : '')
    end
end
