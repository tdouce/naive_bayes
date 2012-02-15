class IndividualsController < ApplicationController
  
  before_filter :find_individual, :only => [:edit, :update, :destroy]

  def index
    @individuals = Individual.order("gender desc")
  end

  def new
    @individual = Individual.new
  end

  def create
    @individual = Individual.new(params[:individual])

    if @individual.save
      flash[:success] = "Individual was created!"
      redirect_to individuals_url
    else
      flash[:failure] = "Individual was NOT created!"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @individual.update_attributes(params[:individual])
      flash[:success] = "Individual was updated"
      redirect_to individuals_url
    else
      flash[:failure] = "Individual was NOT updated"
      render 'edit'
    end
  end

  def destroy

    @individual = Individual.find(params[:id])
    @individual.destroy
    flash[:success] = "Individual was deleted"
    redirect_to individuals_url
  end

  protected

  def find_individual
    @individual = Individual.find(params[:id])
  end
end
