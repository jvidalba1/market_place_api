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

require 'rails_helper'

RSpec.describe Placement, type: :model do
  let(:placement) { FactoryGirl.build :placement }
  subject { placement }

  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }

  it { is_expected.to respond_to :quantity }
end
