class HomeController < ApplicationController
  def index
    @guesthouses = Guesthouse.active
  end
end