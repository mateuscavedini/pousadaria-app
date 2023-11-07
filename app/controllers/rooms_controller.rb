class RoomsController < ApplicationController
  before_action :authenticate_owner!, except: [:show]
  before_action :set_room, only: [:show, :edit, :update, :activated, :deactivated]
  before_action :set_guesthouse, only: [:new, :create]
  before_action :check_room_owner, only: [:edit, :update, :activated, :deactivated]
  before_action :check_guesthouse_owner, only: [:new, :create]
  before_action :check_room_status, only: [:show]

  def show; end

  def new
    @room = @guesthouse.rooms.build
  end

  def create
    @room = @guesthouse.rooms.build(room_params)

    if @room.save
      redirect_to guesthouse_room_path(@guesthouse, @room), notice: 'Quarto cadastrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar o quarto.'
      render :new
    end
  end

  def edit
    @guesthouse = @room.guesthouse
  end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: 'Quarto atualizado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível atualizar o quarto.'
      render :edit
    end
  end

  def activated
    @room.active!

    redirect_to room_path(@room), notice: 'O quarto foi ativado com sucesso.'
  end

  def deactivated
    @room.inactive!

    redirect_to room_path(@room), notice: 'O quarto foi desativado com sucesso.'
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :area, :max_capacity, :daily_rate, :has_bathroom, :has_balcony, :has_air_conditioner, :has_tv, :has_wardrobe, :has_safe, :is_accessible)
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:guesthouse_id])
  end

  def check_guesthouse_owner
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless @guesthouse.owner == current_owner
  end

  def check_room_owner
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless @room.guesthouse.owner == current_owner
  end

  def check_room_status
    unless current_owner == @room.guesthouse.owner
      redirect_to root_path, alert: 'Este quarto está indisponível.' if @room.inactive?
    end
  end
end