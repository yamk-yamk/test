# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  item_total           :integer          default(0), not null
#  tax_rate_id          :integer
#  total                :integer          default(0), not null
#  paid_total           :integer
#  completed_on         :date
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer          default(0), not null
#  additional_tax_total :integer          default(0), not null
#  used_point           :integer          default(0)
#  adjustment_total     :integer          default(0), not null
#  item_count           :integer          default(0), not null
#  lock_version         :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe SingleOrderDetail, type: :model do

  describe 'defined methods' do
    let(:single_order_detail) {create(:single_order_detail)}

    it 'set_completed_on' do
      @single_order_detail = create(:single_order_detail)
      @single_order_detail.completed_on = nil
      expect(@single_order_detail.set_completed_on).to eq single_order_detail.completed_on
    end
  end

end
