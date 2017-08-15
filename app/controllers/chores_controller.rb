class ChoresController < ApplicationController
  def index
    @chores = Chore.all.order(next_due: :asc, cycle_reset: :asc)
    api_call = OpenWeatherMap.new
    @weather = JSON.parse api_call.current_weather_payload
  end

  def show
    @chore = Chore.find(params[:id])
  end

  def new
    @chore = Chore.new
  end

  def edit
    @chore = Chore.find(params[:id])
  end

  def create
    @chore = Chore.new(chore_params)

    if @chore.save
      redirect_to @chore
    else
      render 'new'
    end
  end

  def update
    @chore = Chore.find(params[:id])

    if @chore.update(chore_params)
      redirect_to @chore
    else
      render 'edit'
    end
  end

  def reset_cycle
    @chore = Chore.find(params[:id])
    @chore.reset_cycle_date             # TODO how should I catch failures here?
    @chore.save if @chore.persisted?

    redirect_to chores_path
  end

  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy

    redirect_to chores_path
  end

  private
    def chore_params
      params.require(:chore).permit(:name, :instructions, :interval_days, :interval_type)
    end
end
