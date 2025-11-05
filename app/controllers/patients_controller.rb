class PatientsController < ApplicationController
    before_action :set_patient, only: %i[ show edit update destroy ]
    def index
        @patients = Patient.all
    end

    def show
    end

    def new
        @patient = Patient.new
    end

    def edit
    end

    def create
        @patient = Patient.new(patient_params)

        respond_to do |format|
            if @patient.save
              format.html { redirect_to patients_path, notice: "Patient was successfully created." }
              format.json { render :show, status: :created, location: @patient }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @patent.errors, status: :unprocessable_entity }
            end
        end
    end

    def update 
        respond_to do |format|
            if @patient.update(patient_params)
              format.html { redirect_to patients_path, notice: "Patient was successfully updated." }
              format.json { render :show, status: :ok, location: @patient }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @patient.errors, status: :unprocessable_entity }
            end
        end
    end
    
    def destroy
        @patient.destroy
        redirect_to patients_url, notice: 'Patient was successfully deleted'
    end

    private

    def set_patient
        @patient = Patient.find(params[:id])
    end

    def patient_params
        params.require(:patient).permit(:subject, :otherIDs, :age, :sex, :onsetAge, :handedness, :domHemi, 
        :wada, :fmri, :csm, 
        :surgHemi, :surgType, :surgDescription, :surgDate, 
        :ilae, :engel, :etiology, :mri, 
        :surgHx, :surgHxHemi, :surgHxType, :surgHxDate, 
        :preNP_DOE, :postNP_DOE, :fsiq, :english, 
        :ecog_hemi, :ecog, :implantDate, :explantDate, 
        :vns, :prime, :thalamusStim, :meg, 
        :awakeCsm, :awakeCsm_Tasks, :asleepCsm, :asleepCsm_Tasks, )
    end
end 