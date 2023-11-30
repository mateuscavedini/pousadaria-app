class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500

  private

  def return_500
    render status: 500, json: { message: 'Erro interno de servidor.' }
  end
end