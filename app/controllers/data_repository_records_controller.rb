class DataRepositoryRecordsController < ApplicationController
  def new
    @rppr_id = params[:rppr_id]
    @data_repository_record = DataRepositoryRecord.new()
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    respond_to do |format|
      begin
        @rppr = Rppr.find(data_repository_record_params[:rppr_id]) if data_repository_record_params[:rppr_id].present?
        @data_repository_record = DataRepositoryRecord.new(
          desc: data_repository_record_params[:desc],
          screenshot_evidence: data_repository_record_params[:screenshot_evidence],
          doi: data_repository_record_params[:doi])
        data_repository = DataRepository.find(data_repository_record_params[:data_repository_id])
        raise 'Data Repository not found' if !data_repository.present?
        @data_repository_record.data_repository = data_repository

        @data_repository_record.save!
        flash[:success] = "Data repository record successfully added for the progress report"
        format.js
      rescue => e
        flash[:alert] = "fail to save data repository record. error: #{e.message}"
        puts e.backtrace[0, 10].join("\n\t")
        format.js { render 'message' }
      end
    end
  end

  def edit
    @rppr_id = params[:rppr_id]
    @data_repository_record = DataRepositoryRecord.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    respond_to do |format|
      begin
        @rppr = Rppr.find(data_repository_record_params[:rppr_id]) if data_repository_record_params[:rppr_id].present?
        @data_repository_record = DataRepositoryRecord.find(params[:id])
        @data_repository_record.desc = data_repository_record_params[:desc]
        @data_repository_record.screenshot_evidence = data_repository_record_params[:screenshot_evidence]
        @data_repository_record.doi = data_repository_record_params[:doi]
        @data_repository_record.data_repository = DataRepository.find(data_repository_record_params[:data_repository_id])
        @data_repository_record.save!
        flash[:success] = "Data repository record successfully added for the progress report"
        format.js
      rescue => e
        flash[:alert] = "fail to update data repository record. error: #{e.message}"
        puts e.backtrace[0, 10].join("\n\t")
        format.js { render 'message' }
      end
    end
  end

  def destroy
    respond_to do |format|
      begin
        @data_repository_record = DataRepositoryRecord.find(params[:id])
        @data_repository_record_id = @data_repository_record.id

        flash[:success] = "Data repository record successfully removed for the progress report"
        format.js
      rescue => e
        flash[:alert] = "fail to remove data repository record. error: #{e.message}"
        puts e.backtrace[0, 10].join("\n\t")
        format.js { render 'message' }
      end
    end
  end

  def screenshot
    @data_repository_record = DataRepositoryRecord.find(params[:id])
    if @data_repository_record.present?
      @file = "#{@data_repository_record.screenshot_evidence.path}"
      if @file.present?
        File.open(@file, 'r') do |f|
          send_data f.read, filename: "#{File.basename(@file)}", type: "application/pdf", disposition: 'inline'
        end
      else
        flash[:warning] = "screenshot evidence file not found."
        redirect_to root_path
      end
    else
      flash[:warning] = "DataRepositoryRecord does not exist any more. Please refresh this page to continue."
      redirect_to root_path
    end
  end

  private

  def data_repository_record_params
    @data_repository_record_params ||= params.require(:data_repository_record).permit(:rppr_id, :desc, :screenshot_evidence, :data_repository_id, :doi)
  end
end
