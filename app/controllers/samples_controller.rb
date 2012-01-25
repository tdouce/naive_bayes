class SamplesController < ApplicationController
  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(params[:sample])

    if @sample.save
      redirect_to new_sample_url 
    else
      render :action => 'new'
    end
  end
end
