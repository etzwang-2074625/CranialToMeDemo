class PatientTasksController < ApplicationController
  before_action :set_patient_task, only: [:edit, :update, :destroy]
  
  def index
    demos = Demographic.all

    grouped = demos.group_by { |d| d.master_patient_id.gsub(/[^A-Z0-9]/i, '').upcase[0..4] }

    patients = grouped.map do |base_id, records|
      main = records.find { |r| r.master_patient_id.upcase == base_id } || records.first
      {
        id: base_id,
        demo: main
      }
    end

    # category filter (Research / Clinical / Other)
    if params[:category].present?
      research_prefixes = %w[TA TB TC TS]
      clinical_prefixes = %w[TE TT]

      patients.select! do |p|
        prefix = p[:id][0..1]
        case params[:category].downcase
        when "research"
          research_prefixes.include?(prefix)
        when "clinical"
          clinical_prefixes.include?(prefix)
        when "other"
          !research_prefixes.include?(prefix) && !clinical_prefixes.include?(prefix)
        else
          true
        end
      end
    end

    # search filter
    if params[:search].present?
      query = params[:search].downcase
      patients.select! { |p| p[:id].downcase.include?(query) }
    end

    @patients_paginated = Kaminari.paginate_array(patients).page(params[:page]).per(25)
  end
  
  def show
    @patient_id = params[:id].to_s.upcase

    @patient_task = PatientTask.find_by(master_patient_id: @patient_id)

    @demographic = Demographic.find_by("UPPER(master_patient_id) = ?", @patient_id)

    @demographic_variants = Demographic
      .where("UPPER(master_patient_id) LIKE ?", "#{@patient_id}%")
      .order(:master_patient_id)

    @epilepsy = Epilepsy
      .where("UPPER(master_patient_id) LIKE ?", "#{@patient_id}%")
      .order(:master_patient_id)

    @tasks = PatientTask
      .where("UPPER(master_patient_id) LIKE ?", "#{@patient_id}%")
      .order(:task_name)

    @ccep = Ccep
      .where("UPPER(master_patient_id) LIKE ?", "#{@patient_id}%")
      .order(:task_name)

  end
  
  def new
    @patient_task = PatientTask.new 
  end
  
  def create
    @patient_task = PatientTask.new(patient_task_params)
    @patient_task.master_patient_id = @patient_task.master_patient_id.to_s.strip.upcase

    if @patient_task.save
      redirect_to patient_task_path(@patient_task.master_patient_id)
    else
      flash.now[:alert] = "Could not create patient. Check required fields."
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @patient_task.update(patient_task_params)
      redirect_to patient_task_path(@patient_task.master_patient_id)
    else
      render :edit
    end
  end
  
  def destroy
    patient_task = PatientTask.find(params[:id])
    patient_task.destroy
    redirect_to patient_task_path(@patient_task.master_patient_id)
  end
  
  private
  
  def set_patient_task
    @patient_task = PatientTask.find(params[:id])
  end

  def patient_task_params
    params.require(:patient_task).permit(:master_patient_id, :task_name, :task_count)
  end
end
  
