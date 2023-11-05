class GuesthousesController < ApplicationController
  before_action :authenticate_owner!, except: [:show]
  before_action :set_guesthouse, only: [:show, :edit, :update, :activated, :deactivated]
  before_action :check_owner, only: [:edit, :update, :activated, :deactivated]
  before_action :check_guesthouse_existence, only: [:new, :create]
  before_action :check_owner_and_guesthouse_status, only: [:show]

  def show; end
  
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

  def activated
    @guesthouse.active!
    redirect_to @guesthouse, notice: 'A pousada foi ativada com sucesso.'
  end

  def deactivated
    @guesthouse.inactive!
    redirect_to @guesthouse, notice: 'A pousada foi desativada com sucesso.'
  end

  private

  def set_guesthouse
    @guesthouse = Guesthouse.find(params[:id])
  end

  def guesthouse_params
    params.require(:guesthouse).permit(:corporate_name, :trading_name, :registration_number, :description, :allow_pets, :usage_policy, :check_in, :check_out, :payment_methods, address_attributes: [:id, :street_name, :street_number, :complement, :district, :city, :state, :postal_code], contact_attributes: [:id, :phone, :email])
  end

  def check_owner
    redirect_to root_path, alert: 'Você não possui acesso a essa pousada.' unless current_owner == @guesthouse.owner
  end

  def check_guesthouse_existence
    redirect_to root_path, alert: 'Você já possui uma pousada cadastrada.' if current_owner.guesthouse
  end

  def check_owner_and_guesthouse_status
    unless current_owner == @guesthouse.owner
      redirect_to root_path, alert: 'Esta pousada está desativada.' if @guesthouse.inactive?
    end
  end
end