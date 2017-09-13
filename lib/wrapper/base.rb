module Wrapper
  class Base

    # URL base of the API
    HOST = "http://api.gofrog.dev/1"

    def initialize(options = {})
      options.each do |key, val|
        self.send("#{key}=", val)
      end
    end

    # Instance Methods

    # Delete a record in the API by its ID
    def delete
      self.class.delete("/#{self.class.pluralized_resource}/#{self.id}.json")
    end

    # Create a record in the API
    def save
      self.class.post("/#{self.class.pluralized_resource}.json", info)
    end

    # Class Methods

    def self.all
      get("#{pluralized_resource}.json").map do |item|
        new(item)
      end
    end

    # Pluralize the name of the class, it is would be overwrite if needed
    # Example
    # User.pluralized_resource
    # => users
    # Return => String
    def self.pluralized_resource
      to_s.downcase.pluralize
    end

    def self.find(id)
      new(get("/#{pluralized_resource}/#{id}.json"))
    end

    # Perform an HTTP request via GET
    def self.get(url)
      HTTParty.get(HOST + url).parsed_response
    end

    # Perform an HTTP request via PUT
    def self.put(url)
      HTTParty.put(HOST + url).parsed_response
    end

    # Perform an HTTP request via POST
    def self.post(url, body)
      headers = {'Content-Type' => 'application/json'}
      HTTParty.post(HOST + url, body: body, headers: headers).parsed_response
    end

    # Perform an HTTP request via DELETE
    def self.delete(url)
      HTTParty.delete(HOST + url).parsed_response
    end

    private

    def info
      {
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
          "bodywork": @bodywork,
          "aux_load": "0",
          "aux_unload": "0",
          "description": "Descripción pendiente",
          "comments": "Comentarios adicionales",
          "food": "false",
          "round_trip": "false",
          "signed_documents": "false",
          "deliver_next_day": "false",
          "dangerus": "false",
          "vehicle_type": @kind_vehicle,
          "assured": "false",
          "assurance_value": "0",
          "pick_date": "", # 05/08/2017 7:30 pm
          "all_day": "false",
          "freezer": "false",
          "estimated_weight": "0"
        },
        "deliveries": {
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
        },
        "access_token": "0fad08f3e3e1eeb01d3b931f85f5336b25872cb9c75922e181503560d2daae71"
      }.to_json
    end
  end
end
