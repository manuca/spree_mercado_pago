require 'spec_helper'

module MercadoPago
  describe Notification do
    describe 'without basic parameters' do
      it { expect(Notification.new).not_to be_valid }
    end

    describe 'with unknown topic' do
      it { expect(Notification.new(topic: 'foo', operation_id: 'op123')).not_to be_valid }
    end

    describe 'with correct parameters' do
      it { expect(Notification.new(topic: 'payment', operation_id: 'op123')).to be_valid }
    end
  end
end
