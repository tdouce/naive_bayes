class SamplesController < ApplicationController
  
  # Add when doing ajax
  #respond_to :html, :js

  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(params[:sample])
    #@test_data = Sample.prepare_sample(@sample) 
    @test_data = [130,6,8] 

    if @sample.save
      # Add when doing ajax
      #respond_with(@sample)
      respond_to do |format|
        format.html { redirect_to new_sample_url }
        format.js
      end
    else
      render :action => 'new'
    end
  end
end
