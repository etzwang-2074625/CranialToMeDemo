class RolesController < ApplicationController
  before_action :set_role, only: %i[ show edit update destroy ]

  def index
    @page_name = 'users'
    @roles = Role.order('name')
    @privileges = Authorization::Privilege.privileges
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to roles_path
    else
      flash[:danger] = @role.errors.full_messages.first
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
    if @role.name == "System Administrator"
      flash[:warning] = @role.name + " role is not editable."
      redirect_to roles_path
      return
    end
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:success] = 'Role was successfully updated.'
      redirect_to roles_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if @role.name == "System Administrator"
      flash[:warning] = @role.name + " role may not be destroyed."
    else
      flash[:success] = Role.find(params[:id]).name + " role was deleted."
      Role.find(params[:id]).destroy
    end
    redirect_to roles_path
  end
  
  def update_all
    # Must clear all roles and privileges before giving new roles extra privileges.
    @roles = Role.all
    @privileges = Authorization::Privilege.privileges
    @roles.each do |role|
      role.privileges = Set.new
      if role.name == "System Administrator"
        @privileges.each do |priv|
          role.privileges.add(priv.name)
        end
      end
      role.save
    end

    # Check if checkmarks have been selected
    unless params[:roles]
      redirect_to roles_path
      return
    end
    
    # Update Roles that have checkmarks selected
    params[:roles].each_pair do |id,privs|
      role = Role.find_by_id id
      role.privileges = privs.keys
      role.save
    end
    flash[:success] = 'Role privileges were successfully updated.'
    redirect_to roles_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.require(:role).permit(:name, :privilege_string)
    end
end
