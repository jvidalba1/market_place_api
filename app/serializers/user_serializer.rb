class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :auth_token#, :oelo

  has_many :products

  # def oelo
  #   object.products
  # end
end
