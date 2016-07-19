class Product < ActiveRecord::Base
end

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
end


class Order < ActiveRecord::Base
  has_many :order_items
  depend price: {order_items: :price}
end
