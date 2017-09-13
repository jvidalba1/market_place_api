class Api::V1::ShipmentsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  # =>  PARAMS
  # { 
  #   "cantidad": "5", 
  #   "vehiculo": "carry",
  #   "carroceria": "carry",
  #   "servicio": "inmediato"
  #   "cliente": "1"
  # }
  #
  def create
    # binding.remote_pry

    # client = Client.find(shipment_params["cliente"])

    shipment = Shipment.new({ 
      kind_vehicle: shipment_params["vehiculo"], 
      client_id: shipment_params["cliente"], 
      kind_service: shipment_params["servicio"], 
      bodywork: shipment_params["carroceria"],
      quantity: shipment_params["cantidad"].to_i
    })
    
    result = shipment.validate
    
    if result[:valid]
      render json: result[:shipments], status: 200
    else
      render json: { errors: result[:errors].flatten.uniq }, status: 500
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:cantidad, :vehiculo, :cliente, :servicio, :carroceria)
  end

end
