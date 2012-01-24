class IndividualsController < ApplicationController
  def show
  end

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

      # Redirect to employee index
      redirect_to individuals_url
    else
      flash[:failure] = "Individual was NOT created!"
      render :action => 'new'
    end
  end

  def update
  end

  def edit
  end

  def delete
  end

end
