class SamplesController < ApplicationController
  
  def new
    @sample = Sample.new
  end

  # Use ajax to respond with answer
  def create
    @sample = Sample.new(params[:sample])
    @sample_data = @sample.prepare_sample 

    if @sample.save
      respond_to do |format|
        format.html { redirect_to new_sample_url }
        format.js
      end
    else
      render :action => 'new'
    end
  end
end
