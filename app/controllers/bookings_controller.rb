class BookingsController < ApplicationController
  devise_group :app_user, contains: [:guest, :owner]

  before_action :authenticate_guest!, only: [:create]
  before_action :authenticate_owner!, only: [:ongoing, :finished]
  before_action :authenticate_app_user!, only: [:show, :my_bookings, :canceled]

  before_action :set_room, only: [:new, :validate]
  before_action :set_booking, only: [:show, :ongoing, :finished, :canceled]

  before_action :check_owner, only: [:ongoing]
  before_action :check_guest, only: [:canceled]
  before_action :check_status_pending, only: [:ongoing, :canceled]
  before_action :check_start_date, only: [:ongoing, :canceled]
  
  def new
    @booking = @room.bookings.build
  end

  def validate
    @booking = @room.bookings.build(booking_params)

    if @booking.valid?
      @booking.total_price = @room.calculate_total_price(@booking.start_date, @booking.finish_date)
    else
      flash.now[:alert] = 'Não foi possível fazer a pré-reserva.'
      render :new
    end
  end

  def create
    @booking = current_guest.bookings.build(booking_params)

    if @booking.save
      redirect_to my_bookings_path, notice: 'Reserva confirmada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível confirmar a reserva.'
      render :new
    end
  end

  def my_bookings
    if owner_signed_in?
      @bookings = []
      current_owner.guesthouse.rooms.each do |room|
        room.bookings.each do |booking|
          @bookings << booking
        end
      end
    elsif guest_signed_in?
      @bookings = current_guest.bookings
    end
    
    render :index
  end

  def ongoing
    @booking.ongoing!
    @booking.check_in = Time.current

    redirect_to booking_path(@booking), notice: 'Check-In realizado com sucesso.'
  end

  def finished
    @booking.finished!

    redirect_to booking_path(@booking), notice: 'Status da reserva alterado para Finalizado.'
  end

  def canceled
    @booking.canceled!

    redirect_to booking_path(@booking), notice: 'Reserva cancelada com sucesso.'
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :finish_date, :guests_number, :total_price, :room_id)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
  
  def set_booking
    @booking = Booking.find(params[:id])
  end

  def check_owner
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless current_owner == @booking.room.guesthouse.owner
  end

  def check_guest
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless current_guest == @booking.guest
  end

  def check_status_pending
    redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.pending?
  end
  
  def check_start_date
    if guest_signed_in?
      redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.start_date - Date.current >= 7
    else
      redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless Date.current >= @booking.start_date
    end
  end
end