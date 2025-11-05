class TerminologiesController < ApplicationController
  def index
    @data_dictionaries = DataDictionary.all
  end
end
