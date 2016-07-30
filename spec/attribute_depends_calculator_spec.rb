#encoding: utf-8

require "spec_helper"

describe AttributeDependsCalculator do

  let(:order) {Order.create(price: 100) }
  let(:product) {Product.create(price: 100, name: 'iPhone')}
  let(:order_item) {OrderItem.create(order: order, product: product, price: product.price)}

  context 'Macro' do
    it 'should respond to depends macro' do
      expect(ActiveRecord::Base.respond_to?(:depend)).to be true
      expect(ActiveRecord::Base.respond_to?(:attribute_depend)).to be true
    end
  end

  context 'Depends' do

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

    it 'should auto calculate when destroy an order item' do
      origin_price = order.price
      OrderItem.create(order: order, product: order_item.product, price: origin_price)
      expect(order.reload.price).to eq(origin_price * 2)
      OrderItem.destroy(order.id)
      expect(order.reload.price).to eq(origin_price)
    end

  end

  context 'Parameter' do

    it 'should raise error when operator incorrect' do

      expect do
        Order.class_eval do
          attribute_depend price: {order_items: :price, operator: :divide}
        end
      end.to raise_error

    end

  end

end
