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
    quantity = shipment_params["cantidad"].to_i

    # client = Client.find(shipment_params["cliente"])

    shipment = Shipment.new({ 
      kind_vehicle: shipment_params["vehiculo"], 
      client_id: shipment_params["cliente"], 
      kind_service: shipment_params["servicio"], 
      bodywork: shipment_params["carroceria"]
    })

    services_ids = []
    errors = []
    if shipment.valid?
      quantity.times do |t|
        response = shipment.save
        
        if response["response"]
          response["response"]["errors"].each {|error| errors.push(error)}
        else
          services_ids << response["data"]["shipment"]["shipment_id"]
        end
      end
    else
      errors = shipment.errors.messages.map do |key, value|
        value.map do |v|
        "#{key.to_s} #{v}"
        end
      end.flatten
    end
  
    if errors.any?
      render json: { errors: errors.flatten.uniq }, status: 500
    else
      data = { "services_ids": services_ids }
      render json: data, status: 200
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:cantidad, :vehiculo, :cliente, :servicio, :carroceria)
  end

end
