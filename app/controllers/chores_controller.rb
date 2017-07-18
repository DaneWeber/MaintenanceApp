require 'date'

class ChoresController < ApplicationController
  def index
    @chores = Chore.all.order(nextdue: :asc, updated_at: :asc)
  end

  def show
    @chore = Chore.find(params[:id])
  end

  def new
  end

  def create
    @chore = Chore.new(chore_params)

    @chore.save
    redirect_to @chore
  end

  def update
    @chore = Chore.find(params[:id])
    if @chore.lastdone == Date.today && @chore.nextdue == Date.today + @chore.interval_days
      @chore.touch
    else
      @chore.lastdone = Date.today
      @chore.nextdue = @chore.lastdone + @chore.interval_days
      @chore.save
    end
    redirect_to chores_path
  end

  private
    def chore_params
      params.require(:chore).permit(:name, :instructions, :interval_days)
    end
end
