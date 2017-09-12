require 'net/http'
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
    kind_vehicle = shipment_params["vehiculo"]
    client_id = shipment_params["cliente"]
    kind_service = shipment_params["servicio"]
    bodywork = shipment_params["carroceria"]

    # client = Client.find(client_id)

    # search origin_lat & origin_lng with client address 
    info = {
      "shipment": {
        "from_contact_attributes": { # client information
          "first_name": "Mateo",
          "last_name": "Vidal", 
          "company_name": "casa", 
          "phone": "3022871791", 
          "address_1": "Circular 4 #74-48,202", 
          "city": "medellin"
        },
        "origin_lat": "6.244162385", # meanwhile burned
        "origin_lng": "-75.593791542", # meanwhile burned
        "weight": "0",
        "bodywork": bodywork,
        "aux_load": "0",
        "aux_unload": "0",
        "description": "Descripción pendiente",
        "comments": "Comentarios adicionales",
        "food": "false",
        "round_trip": "false",
        "signed_documents": "false",
        "deliver_next_day": "false",
        "dangerus": "false",
        "vehicle_type": kind_vehicle,
        "assured": "false",
        "assurance_value": "0",
        "pick_date": "",
        "all_day": "false",
        "freezer": "false",
        "estimated_weight": "0"
      }
    }

    info["deliveries"] = {
      "0": {
        "to_contact_attributes": {
          "first_name": "EAFIT", 
          "last_name": "Universidad", 
          "company_name": "Universidad EAFIT", 
          "phone": "1234", 
          "address_1": "Carrera 49 # 7 sur - 50,", 
          "city": "medellin"
        }
      }
    }
    
    info["access_token"] =  "0fad08f3e3e1eeb01d3b931f85f5336b25872cb9c75922e181503560d2daae71"

    url = "http://api.gofrog.dev/1/shipments"
    uri = URI.parse(url)

    header = { 
      'Content-Type' => 'application/json'
    }

    body = info

    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Post.new(uri.path, header)
    request.body = body.to_json

    services_ids = []
    errors = false
    quantity.times do |t|
      #shipment = Shipment.create() 
      response = http.request(request)
      response_body = JSON.parse(response.body)

      if response_body["data"]["errors"]
        errors = true
        break
      else
        services_ids << JSON.parse(response.body)["data"]["shipment"]["shipment_id"]
      end
    end

    if errors
      render json: { errors: response_body["data"]["errors"] }, status: 500
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
