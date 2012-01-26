class SamplesController < ApplicationController
  
  # Add when doing ajax
  #respond_to :html, :js

  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(params[:sample])

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
