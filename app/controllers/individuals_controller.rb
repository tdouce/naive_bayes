class IndividualsController < ApplicationController

  def index
    @individuals = Individual.order("gender desc")
  end

  def new
    @individual = Individual.new
  end

  def create
    @individual = Individual.new(params[:individual])

    # Put default value to false in database
    @individual.set_trained_status_false

    if @individual.save
      flash[:success] = "Individual was created!"
      redirect_to individuals_url
    else
      flash[:failure] = "Individual was NOT created!"
      render :action => 'new'
    end
  end

  def edit
    @individual = Individual.find(params[:id])
  end

  def update
    @individual = Individual.find(params[:id])
    # User call_back before_save
    @individual.set_trained_status_false

    if @individual.update_attributes(params[:individual])
      flash[:success] = "Individual was updated"
      redirect_to individuals_url
    else
      flash[:failure] = "Individual was NOT updated"
      render 'edit'
    end
  end

  def destroy
    Individual.find(params[:id]).destroy
    flash[:success] = "Individual was deleted"
    redirect_to individuals_url
  end

end
