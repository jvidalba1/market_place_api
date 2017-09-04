# == Schema Information
#
# Table name: placements
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :placement do
    order
    product
    quantity 1
  end
end
