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

class Order < ApplicationRecord
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :total, presence: true
  validates :total, numericality: true

  validates :user_id, presence: true

  before_validation :set_total!

  def set_total!
    self.total = products.map(&:price).sum
  end
end
