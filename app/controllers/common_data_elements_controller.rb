class CommonDataElementsController < ApplicationController
    def index
      @common_data_elements = CommonDataElement.all
  
      if params[:search].present?
        @common_data_elements = @common_data_elements.where("LOWER(element_name) LIKE ?", "%#{params[:search]}%")
      end
    end
  
    def show
      @common_data_element = CommonDataElement.find(params[:id])
    end
  end
  

