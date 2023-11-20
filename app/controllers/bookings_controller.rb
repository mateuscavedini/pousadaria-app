class BookingsController < ApplicationController
  devise_group :app_user, contains: [:guest, :owner]

  before_action :authenticate_guest!, only: [:create]
  before_action :authenticate_app_user!, only: [:my_bookings]

  before_action :set_room, only: [:new, :validate]
  
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

  private

  def booking_params
    params.require(:booking).permit(:start_date, :finish_date, :guests_number, :total_price, :room_id)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end