class CcepsController < ApplicationController
  before_action :set_ccep, only: [:show, :edit, :update, :destroy]
  
  def index
    @cceps = Ccep.all
  
    if params[:search].present?
      @cceps = @cceps.where("LOWER(master_patient_id) LIKE ?", "%#{params[:search]}%")
    end

    @cceps = @cceps.order(:master_patient_id).page(params[:page]).per(25)
  end
  
  def show
  end
  
  def new
    @ccep = Ccep.new
  end
  
  def create
    @ccep = Ccep.new(ccep_params)
    @ccep.master_patient_id = @ccep.master_patient_id.to_s.strip.upcase

    if @ccep.save
      redirect_to patient_task_path(@ccep.master_patient_id)
    else
      flash.now[:alert] = "Could not create patient. Check required fields."
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @ccep.update(ccep_params)
        redirect_to patient_task_path(@ccep.master_patient_id)
    else
      render :edit
    end
  end
  
  def destroy
    ccep = Ccep.find(params[:id])
    ccep.destroy
    redirect_to patient_task_path(@ccep.master_patient_id)
  end
  
  private
  
  def set_ccep
    @ccep = Ccep.find(params[:id])
  end
  
  def ccep_params
    allowed = Ccep.column_names.map(&:to_sym) - [:id, :created_at, :updated_at]
    params.require(:ccep).permit(allowed)
  end
end
  

  