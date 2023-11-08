class SeasonalRatesController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_room, only: [:new, :create]
  before_action :set_seasonal_rate, only: [:edit, :update]
  before_action :check_owner
  
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

  def edit; end

  def update
    if @seasonal_rate.update(seasonal_rate_params)
      redirect_to @seasonal_rate.room, notice: 'Preço Sazonal atualizado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível atualizar o preço sazonal.'
      render :edit
    end
  end

  private

  def seasonal_rate_params
    params.require(:seasonal_rate).permit(:start_date, :finish_date, :rate)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_seasonal_rate
    @seasonal_rate = SeasonalRate.find(params[:id])
  end

  def check_owner
    if @room.present?
      return if current_owner == @room.guesthouse.owner
    else
      return if current_owner == @seasonal_rate.room.guesthouse.owner
    end
    
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.'
  end
end