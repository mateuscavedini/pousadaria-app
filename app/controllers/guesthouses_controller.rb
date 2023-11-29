class GuesthousesController < ApplicationController
  before_action :authenticate_owner!, except: [:show, :search_by_city, :search_by_term]

  before_action :set_guesthouse, only: [:show, :edit, :update, :activated, :deactivated]
  before_action :set_query, only: [:search_by_city, :search_by_term]

  before_action :check_owner, only: [:edit, :update, :activated, :deactivated]
  before_action :check_guesthouse_existence, only: [:new, :create]
  before_action :check_guesthouse_status, only: [:show]

  def show
    @recent_reviews = @guesthouse.reviews.order(created_at: :desc).limit(3)
  end
  
  def new
    @guesthouse = Guesthouse.new
    @guesthouse.build_address
    @guesthouse.build_contact
  end

  def create
    @guesthouse = current_owner.build_guesthouse(guesthouse_params)
    
    if @guesthouse.save
      redirect_to @guesthouse, notice: 'Pousada cadastrada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar a pousada.'
      render :new
    end
  end

  def edit; end
  
  def update
    if @guesthouse.update(guesthouse_params)
      redirect_to @guesthouse, notice: 'Pousada atualizada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível atualizar a pousada.'
      render :edit
    end
  end

  def my_guesthouse
    @guesthouse = current_owner.guesthouse
    render :show
  end

  def search_by_city
    @guesthouses = Guesthouse.joins(:address).where(address: { city: @query }).order(trading_name: :asc)
    render :search
  end

  def search_by_term
    term = "%#{@query}%"
    @guesthouses = Guesthouse.active.joins(:address).where("trading_name LIKE :term OR addresses.city LIKE :term OR addresses.district LIKE :term", term: term).order(:trading_name)
    render :search
  end

  def activated
    @guesthouse.active!
    redirect_to @guesthouse, notice: 'A pousada foi ativada com sucesso.'
  end

  def deactivated
    @guesthouse.inactive!
    redirect_to @guesthouse, notice: 'A pousada foi desativada com sucesso.'
  end

  private

  def guesthouse_params
    params.require(:guesthouse).permit(:corporate_name, :trading_name, :registration_number, :description, :allow_pets, :usage_policy, :check_in, :check_out, :payment_methods, address_attributes: [:id, :street_name, :street_number, :complement, :district, :city, :state, :postal_code], contact_attributes: [:id, :phone, :email])
  end

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end

  def set_query
    @query = params[:query]
  end

  def check_owner
    redirect_to root_path, alert: 'Você não possui acesso a essa pousada.' unless current_owner == @guesthouse.owner
  end

  def check_guesthouse_existence
    redirect_to root_path, alert: 'Você já possui uma pousada cadastrada.' if current_owner.guesthouse
  end

  def check_guesthouse_status
    unless current_owner == @guesthouse.owner
      redirect_to root_path, alert: 'Esta pousada está desativada.' if @guesthouse.inactive?
    end
  end
end