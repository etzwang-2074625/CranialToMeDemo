class ProjectsController < ApplicationController
  include ApplicationHelper, SessionsHelper, UsersHelper
  before_action :signed_in_user
  before_action :set_project, only: %i[ show edit update destroy ]

  def print_dms_plan
    @project = Project.where(id: flex_params[:id]).first
    if @project.present?
      
      @file = "#{@project.dms_plan_file.path}"
      if @file.present?
        File.open(@file, 'r') do |f|
          send_data f.read, filename: "#{File.basename(@file)}", type: "application/pdf", disposition: 'inline'
        end
      else
        flash[:warning] = "DMS plan file not found."
        redirect_to edit_project_path(@project)
      end
    else
      flash[:warning] = "Award does not exist any more. Please refresh this page to continue."
      redirect_to root_path
    end
  end

  # TODO: move to rpprs controller
  def approve_rppr
    @project = Project.where(id: flex_params[:id]).first
    @rppr = Rppr.where(id: flex_params[:rppr_id]).first
    @rppr.status = 4
    @rppr.save
    ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)

    flash[:success] = "DMS progress report approved successfully"
    redirect_to welcome_dashboard_path
  end

  # TODO: move to rpprs controller
  def return_rppr
    @project = Project.where(id: flex_params[:id]).first
    @rppr = Rppr.where(id: flex_params[:rppr_id]).first
    @rppr.status = 3
    @rppr.save
    ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)

    flash[:info] = "DMS progress report status updated to Return for Editing"
    redirect_to welcome_dashboard_path
  end

  def flex_params
    request.parameters
  end

  def reports
  end

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  def upload_nih_awards
    file = params[:file]
    flash[:success] = ""
    flash[:error] = ""

    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    csv_text = File.read(file.path)
    csv_text = csv_text.encode(Encoding.find('ASCII'), encoding_options)
    csv_data = CSV.parse(csv_text, headers: true)
    csv_data.each do |row|
      next if row.to_h.values.all? { |v| v.nil? } || row['Award ID'].nil? || row['Contact PI'].nil? || row['PI Email'].nil?

      project_number = row['Award ID']
      contact_pi = row['Contact PI']
      # mpi = row['MPI']
      project_title = row['Proposal Title']
      project_start_date = row['Project Period Start']
      project_end_date = row['Project Period End']
      # budget_start_date = row['Budget Period Start']
      # budget_end_date = row['Budget Period End']
      # total_cost = row['DMS Budget']
      pi_email = row['PI Email'].downcase
      granting_agency = row['Granting Agency']
      # contact_pi_uthealth_id = row['Contact PI employee ID']
      # contact_pi_era_id = row['Contact PI eRA Commons ID']
      # department = row['Department']
      # suffix = row['Suffix']
      # cfda_code = row['CFDA Code']
      public_starts_project_number = row['UTSTART Project Number']
      dms_plan_file_name = row['DMS Plan File Name']
      due_dates = row["RPPR Due Dates"].nil? ? nil : row["RPPR Due Dates"].strip

      project = Project.where("lower(project_number) = ?", project_number.downcase).first
      if project.nil?
        project = Project.new
        project.uthealth_primary_grantee = true
      end

      project["project_number"] = project_number.strip
      if contact_pi.present?
        contact_pi = contact_pi.strip.split(",")
        project["contact_pi"] = contact_pi.last + " " + contact_pi.first
      end
      # if mpi.present?
      #   mpi = mpi.strip.split("|")
      #   project["other_pis"] = mpi
      # end
      project["project_title"] = project_title.nil? ? nil : project_title.strip
      project["project_start_date"] = project_start_date.nil? ? nil : project_start_date.strip
      project["project_end_date"] = project_end_date.nil? ? nil : project_end_date.strip
      # project["budget_start_date"] = budget_start_date.nil? ? nil : budget_start_date.strip
      # project["budget_end_date"] = budget_end_date.nil? ? nil : budget_end_date.strip
      # project["total_cost"] = total_cost.nil? ? nil : total_cost.strip
      project["project_institution"] = "UTHealth"
      project["pi_email"] = pi_email
      project["granting_agency"] = granting_agency.nil? ? nil : granting_agency.strip
      # project["contact_pi_uthealth_id"] = contact_pi_uthealth_id.nil? ? nil : contact_pi_uthealth_id.strip
      # project["contact_pi_era_id"] = contact_pi_era_id.nil? ? nil : contact_pi_era_id.strip
      # project["department"] = department.nil? ? nil : department.strip
      # project["suffix"] = suffix.nil? ? nil : suffix.strip
      # project["cfda_code"] = cfda_code.nil? ? nil : cfda_code.strip
      project["public_starts_project_number"] = public_starts_project_number.nil? ? nil : public_starts_project_number.strip
      project["dms_plan_file_name"] = dms_plan_file_name.nil? ? nil : dms_plan_file_name.strip

      if !project.save
        flash[:error] += "Project #{project_number} can not be imported.<br>"
      else
        if project["pi_email"].present?
          user = User.where(email: project["pi_email"]).first
          if !user.present?
            user = User.create(user_firstname: contact_pi.first, user_lastname: contact_pi.last, email: project["pi_email"], password: 'deput_password', password_confirmation: 'deput_password')
            user.roles << Role.find_by_name('Project PI')
            user.save
          end
        end
        if !project.rpprs.present?
          start_year = project.project_start_date.year
          end_year = project.project_end_date.year
          start_date = project.project_start_date
          end_date = project.project_end_date
          curr_date = project.project_start_date
          if due_dates.present?
            due_dates = due_dates.split("|")
            due_dates.map!{ |date| Date.parse(date) }
            due_dates = due_dates.sort
          else
            due_dates = []
          end
          count = 0
          p due_dates  
          if start_date.present? && end_date.present?
            while(curr_date < end_date) do
              rppr = Rppr.new
              rppr.project_id = project.id
              rppr.start_date = curr_date
              rppr.year_start = curr_date.year
              if curr_date.next_year > end_date
                rppr.end_date = end_date
              else
                rppr.end_date = curr_date.next_year - 1
              end
              rppr.year_end = rppr.end_date.year
              curr_date = curr_date.next_year
              if count < due_dates.length
                rppr.due_date = due_dates[count]
              end
              count += 1
              rppr.save

              if rppr.current?
                days_until_due = (rppr.due_date.to_date - Date.today).to_i
                ProgressReportMailer.remind_due(rppr, days_until_due).deliver_later
              end
            end
          end
        end
        
      end
    end
    if flash[:error] == ""
      flash[:success] = "Projects have been imported successfully!"
    end

    redirect_to welcome_dashboard_path and return
  rescue => e
    flash[:alert] = "System error when uplaoding #{e.message}"
    puts e.backtrace[0, 10].join("\n\t")
    redirect_to welcome_dashboard_path and return
  end

  def upload_dms_plan_file
    # if !current_user.has_privilege?('APPROVE_DMS')
    #   @success = false
    #   @message = "You don't have privilege to create donors."
    #   return 
    # end
    dms_files = params[:files]
    flash[:error] = ""
    @success = true
    begin
      dms_files.each do |dms_file|
        dms_file_name = dms_file.original_filename
        existing_record = Project.where(dms_plan_file_name: dms_file_name).first
        if existing_record.present?
          existing_record.dms_plan_file = dms_file
          existing_record.save
        else 
          @success = false
          flash[:error] += "The file #{dms_file_name} is not associated with any project."
        end
      end
    rescue => e
      @success = false
      flash[:error] = "There is an error, please contact the system administrator: \n#{e}."
      return
    end
    if @success
      flash[:success] = "Files have been uploaded successfully!"
    end
  end

  def get_rppr
    project_id = params[:project_id]
    @project = Project.where(id: project_id).first
    @rpprs = {}
    if @project.present?
      @rpprs = @project.rpprs
    end
  end

  # POST /projects or /projects.json
  def create
    p_params = flex_params[:project]
    dms_plan = p_params[:dms_plan_file]
    p_params.delete(:dms_plan_file)

    @project = Project.new(p_params)

    respond_to do |format|

      if dms_plan.present?
        @project.dms_plan_file = dms_plan
      end

      if @project.save
        ActionLog.create(user_id: current_user.id, subject_id: @project.id, subject_type: @project.class.name, data: @project.saved_changes)
        format.html { redirect_to welcome_dashboard_path, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    p_params = flex_params[:project]
    dms_plan = p_params[:dms_plan_file]
    p_params.delete(:dms_plan_file)

    respond_to do |format|
      if dms_plan.present?
        @project.dms_plan_file = dms_plan
      end

      if @project.update(p_params)
        ActionLog.create(user_id: current_user.id, subject_id: @project.id, subject_type: @project.class.name, data: @project.saved_changes)
        format.html { redirect_to welcome_dashboard_path, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      ActionLog.create(user_id: current_user.id, subject_id: @project.id, subject_type: @project.class.name, data: { destroyed: @project.attributes })
      format.html { redirect_to welcome_dashboard_path, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:uthealth_primary_grantee,:project_institution,:project_title,:public_starts_project_number,:project_number,:contact_pi,:contact_pi_uthealth_id,:contact_pi_era_id,:other_pis,:department,:suffix,:budget_start_date,:budget_end_date,:cfda_code,:pi_email, :project_start_date, :project_end_date, :granting_agency, :dms_status)
    end
end
