class ChoresController < ApplicationController
  def index
    @chores = Chore.all
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

  private
    def chore_params
      params.require(:chore).permit(:name, :instructions, :interval_days)
    end
end
