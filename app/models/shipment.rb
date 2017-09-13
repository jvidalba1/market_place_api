class Shipment < Wrapper::Base
  include ActiveModel::Validations

  attr_accessor :kind_vehicle, :client_id, :kind_service, :bodywork, :quantity

  validates :kind_vehicle, presence: true
  validates :client_id, presence: true
  validates :bodywork, presence: true
  validates :quantity, presence: true, numericality: true

  def validate
    if self.valid?
      result_creation = creation

      if result_creation[:valid]
        shipments = confirmation(result_creation[:shipment_ids])
      else
        errors = result_creation["errors"]
      end
    else
      errors = self.errors.messages.map do |key, value|
        value.map do |v|
        "#{key.to_s} #{v}"
        end
      end.flatten
    end

    errors.nil? ? { valid: true, shipments: shipments } : { valid: false, errors: errors }
  end

  def creation
    shipment_ids = []
    errors = []

    quantity.times do |t|
      response = self.create
      
      if response["response"]
        return { valid: false, errors: response["response"]["errors"] }
        # response["response"]["errors"].each { |error| errors.push(error) }
      else
        shipment_ids << response["data"]["shipment"]["shipment_id"]
      end
    end

    { valid: true, shipment_ids: shipment_ids }
  end

  def confirmation(shipment_ids)
    shipment_ids.map { |id| self.confirm(id.to_s) }
  end
end
