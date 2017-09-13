class Shipment < Wrapper::Base
  include ActiveModel::Validations

  attr_accessor :kind_vehicle, :client_id, :kind_service, :bodywork, :quantity

  validates :kind_vehicle, presence: true
  validates :client_id, presence: true
  validates :bodywork, presence: true
  validates :quantity, presence: true, numericality: true

  def validate
    shipment_ids = []
    errors = []

    if self.valid?
      quantity.times do |t|
        response = self.save
        
        if response["response"]
          response["response"]["errors"].each {|error| errors.push(error)}
        else
          shipment_ids << response["data"]["shipment"]["shipment_id"]
        end
      end
    else
      errors = self.errors.messages.map do |key, value|
        value.map do |v|
        "#{key.to_s} #{v}"
        end
      end.flatten
    end

    if errors.any? 
      { valid: false, errors: errors }
    else
      { valid: true, shipment_ids: shipment_ids}
    end
  end
end
