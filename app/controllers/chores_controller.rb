require 'date'

class ChoresController < ApplicationController
  def index
    @chores = Chore.all.order(nextdue: :asc, cycle_reset: :asc)
  end

  def show
    @chore = Chore.find(params[:id])
  end

  def new
  end

  # def edit
  #   @chore = Chore.find(params[:id])
  # end

  def create
    @chore = Chore.new(chore_params)

    @chore.save
    redirect_to @chore
  end

  def update
    @chore = Chore.find(params[:id])
    @chore.update!({:lastdone => Date.today,
                    :nextdue => Date.today + @chore.interval_days,
                    :cycle_reset => Time.now})
    redirect_to chores_path
  end

  private
    def chore_params
      params.require(:chore).permit(:name, :instructions, :interval_days)
    end
end
