class EpilepsiesController < ApplicationController
  before_action :set_epilepsy, only: [:show, :edit, :update, :destroy]
  
  def index
    @epilepsies = Epilepsy.all
  
    if params[:search].present?
      @epilepsies = @epilepsies.where("LOWER(master_patient_id) LIKE ?", "%#{params[:search]}%")
    end

    @epilepsies = @epilepsies.order(:master_patient_id).page(params[:page]).per(25)
  end
  
  def show
  end
  
  def new
    @epilepsy = Epilepsy.new
  end
  
  def create
    @epilepsy = Epilepsy.new(epilepsy_params)
    @epilepsy.master_patient_id = @epilepsy.master_patient_id.to_s.strip.upcase

    if @epilepsy.save
      redirect_to patient_task_path(@epilepsy.master_patient_id)
    else
      flash.now[:alert] = "Could not create patient. Check required fields."
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @epilepsy.update(epilepsy_params)
        redirect_to patient_task_path(@epilepsy.master_patient_id)
    else
      render :edit
    end
  end
  
  def destroy
    epilepsy = Epilepsy.find(params[:id])
    epilepsy.destroy
    redirect_to patient_task_path(@epilepsy.master_patient_id)
  end
  
  private
  
  def set_epilepsy
    @epilepsy = Epilepsy.find(params[:id])
  end
  
  def epilepsy_params
    allowed = Epilepsy.column_names.map(&:to_sym) - [:id, :created_at, :updated_at]
    params.require(:epilepsy).permit(allowed)
  end
end



