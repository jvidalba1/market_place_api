# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderSerializer < ActiveModel::Serializer
  attributes :id
end
