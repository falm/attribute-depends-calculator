#encoding: utf-8

class OrderItem < ActiveRecord::Base
  belongs_to :product, class_name: 'Product'
  belongs_to :order
end

class Product < ActiveRecord::Base

  has_many :items, class_name: 'OrderItem'
  depend sells_count: {items: :id}
end

class Order < ActiveRecord::Base
  has_many :order_items
  depend price: {order_items: :price}
end
