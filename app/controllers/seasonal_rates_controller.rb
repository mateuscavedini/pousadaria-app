class SeasonalRatesController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create]
  before_action :set_room, only: [:new, :create]
  before_action :check_room_owner, only: [:new, :create]
  
  def new
    @seasonal_rate = @room.seasonal_rates.build
  end

  def create
    @seasonal_rate = @room.seasonal_rates.build(seasonal_rate_params)

    if @seasonal_rate.save
      redirect_to @room, notice: 'Preço Sazonal cadastrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar o preço sazonal.'
      render :new
    end
  end

  private

  def seasonal_rate_params
    params.require(:seasonal_rate).permit(:start_date, :finish_date, :rate)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def check_room_owner
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless @room.guesthouse.owner == current_owner
  end
end