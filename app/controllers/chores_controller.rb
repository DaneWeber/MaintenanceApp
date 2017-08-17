FUTURE_WEATHER_FORECAST_DAYS = 15

class ChoresController < ApplicationController
  def index
    @chores = Chore.all.order(next_due: :asc, cycle_reset: :asc)
    @not_due, @today = @chores.partition { |x| x.next_due.nil? }
    @today, @future = @today.partition { |x| x.next_due <= Date.today }
    @future, @forecast = @future.partition { |x| x.next_due > Date.today + FUTURE_WEATHER_FORECAST_DAYS }
    @forecast = @forecast.group_by { |x| x.next_due }
    @gaps = @forecast.keys.zip((@forecast.keys << Date.today).sort.each_cons(2).map { |a,b| (b - a).to_i })
    @forecast_remainder = ((Date.today + FUTURE_WEATHER_FORECAST_DAYS) - @gaps[-1][0]).to_i
    @gaps = @gaps.to_h
    # byebug
    @weather = JSON.parse OpenWeatherMap.new.current_weather_payload
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
