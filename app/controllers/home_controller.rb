class HomeController < ApplicationController
  def index
    @guesthouses = Guesthouse.active.order(created_at: :desc)
    @recent_guesthouses = @guesthouses.slice(0, 3)
    @guesthouses -= @recent_guesthouses
  end
end