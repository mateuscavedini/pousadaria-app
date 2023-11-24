class ReviewsController < ApplicationController
  before_action :authenticate_guest!, only: [:new, :create]

  before_action :set_booking, only: [:new, :create]

  def new
    @review = @booking.build_review
  end

  def create
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end