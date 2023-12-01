class BookingsController < ApplicationController
  devise_group :app_user, contains: [:guest, :owner]

  before_action :authenticate_guest!, only: [:create]
  before_action :authenticate_owner!, only: [:ongoing, :confirmed_check_out, :finished, :my_ongoing_bookings]
  before_action :authenticate_app_user!, only: [:show, :my_bookings, :canceled]

  before_action :set_room, only: [:new, :validate]
  before_action :set_booking, only: [:show, :ongoing, :confirmed_check_out, :finished, :canceled]

  before_action :check_owner, only: [:ongoing, :confirmed_check_out, :finished]
  before_action :check_app_user, only: [:show, :canceled]
  before_action :check_status_pending, only: [:ongoing, :canceled]
  before_action :check_status_ongoing, only: [:confirmed_check_out, :finished]
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

  def my_ongoing_bookings
    @bookings = []

    current_owner.guesthouse.rooms.each do |room|
      room.bookings.ongoing.each do |booking|
        @bookings << booking
      end
    end

    render :index
  end

  def ongoing
    @booking.update!(status: :ongoing, check_in: Time.zone.now)

    redirect_to booking_path(@booking), notice: 'Check-In realizado com sucesso.'
  end

  def canceled
    @booking.canceled!

    redirect_to booking_path(@booking), notice: 'Reserva cancelada com sucesso.'
  end

  def confirmed_check_out
    @updated_total_price = @booking.room.calculate_proportional_total_price(@booking.check_in, Time.zone.now)
    render :confirm_check_out
  end

  def finished
    check_out_params = params.require(:booking).permit(:payment_method, :total_price)
    @booking.update!(status: :finished, check_out: Time.zone.now, payment_method: check_out_params[:payment_method], total_price: check_out_params[:total_price])

    redirect_to booking_path(@booking), notice: 'Check-Out realizado com sucesso.'
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

  def check_app_user
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless current_guest == @booking.guest || current_owner == @booking.room.guesthouse.owner
  end

  def check_status_pending
    redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.pending?
  end

  def check_status_ongoing
    redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.ongoing?
  end
  
  def check_start_date
    if guest_signed_in?
      redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.start_date - Time.zone.now.to_date >= 7
    elsif owner_signed_in?
      redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless Time.zone.now.to_date >= @booking.start_date
    end
  end
end