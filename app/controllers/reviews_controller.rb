class ReviewsController < ApplicationController
  before_action :authenticate_owner!, only: [:my_reviews, :reply]
  before_action :authenticate_guest!, only: [:new, :create]

  before_action :set_booking, only: [:new, :create]
  before_action :set_review, only: [:reply]

  before_action :check_guest, only: [:new, :create]
  before_action :check_owner, only: [:reply]
  before_action :check_status_finished, only: [:new, :create]

  def new
    @review = @booking.build_review
  end

  def create
    @review = @booking.build_review(review_params)

    if @review.save
      redirect_to @booking, notice: 'Avaliação registrada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível registrar a avaliação.'
      render :new
    end
  end

  def my_reviews
    @guesthouse = current_owner.guesthouse
    @reviews = []

    @guesthouse.rooms.each do |room|
      room.bookings.finished.each do |booking|
        @reviews << booking.review
      end
    end

    render :index
  end

  def reply
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def check_guest
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless current_guest == @booking.guest
  end

  def check_owner
    redirect_to root_path, alert: 'Você não tem acesso a esse recurso.' unless current_owner == @review.booking.room.guesthouse.owner
  end

  def check_status_finished
    redirect_to root_path, alert: 'Recurso indisponível para esta reserva.' unless @booking.finished?
  end
end