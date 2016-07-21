#encoding: utf-8

require "spec_helper"

describe AttributeDependsCalculator do

  let(:order) {Order.create(price: 100) }
  let(:product) {Product.create(price: 100, name: 'iPhone')}
  let(:order_item) {OrderItem.create(order: order, product: product, price: product.price)}

  context 'Macro' do
    it 'should respond to depends macro' do
      expect(ActiveRecord::Base.respond_to?(:depend)).to be true
    end
  end

  context 'Dpends' do

    it 'should auto calculate when order item changes' do
      expect(order.price).to eq(order_item.price)
      order_item.update(price: 120)
      expect(order.reload.price).to eq(120)
    end

    it 'should auto calculate when create new order item' do
      origin_price = order.price
      OrderItem.create(order: order, product: order_item.product, price: 244)
      expect(order.reload.price).to eq(origin_price + 244)
    end

  end



end
