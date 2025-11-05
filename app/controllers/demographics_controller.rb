class DemographicsController < ApplicationController
  before_action :set_demographic, only: [:show, :edit, :update, :destroy]
  
  def index
    @demographics = Demographic.all
  
    if params[:search].present?
      @demographics = @demographics.where("LOWER(master_patient_id) LIKE ?", "%#{params[:search]}%")
    end

    @demographics = @demographics.order(:master_patient_id).page(params[:page]).per(25)
  end
  
  def show
  end
  
  def new
    @demographic = Demographic.new
  end
  
  def create
    @demographic = Demographic.new(demographic_params)
    @demographic.master_patient_id = @demographic.master_patient_id.to_s.strip.upcase

    if @demographic.save
      redirect_to patient_tasks_path
    else
      flash.now[:alert] = "Could not create patient. Check required fields."
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @demographic.update(demographic_params)
      redirect_to patient_task_path(@demographic.master_patient_id)
    else
      render :edit
    end
  end
  
  def destroy
    demographic = Demographic.find(params[:id])
    demographic.destroy
    redirect_to patient_tasks_path
  end
  
  private
  
  def set_demographic
    @demographic = Demographic.find(params[:id])
  end
  
  def demographic_params
    allowed = Demographic.column_names.map(&:to_sym) - [:id, :created_at, :updated_at]
    params.require(:demographic).permit(allowed)
  end
end
  

  