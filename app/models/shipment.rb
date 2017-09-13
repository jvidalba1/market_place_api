class Shipment < Wrapper::Base
  include ActiveModel::Validations

  attr_accessor :kind_vehicle, :client_id, :kind_service, :bodywork

  validates :kind_vehicle, presence: true
  validates :client_id, presence: true
  validates :bodywork, presence: true

end
