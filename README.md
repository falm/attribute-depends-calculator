# Attribute Depends Calculator [![Build Status](https://travis-ci.org/falm/attribute-depends-calculator.svg?branch=master)](https://travis-ci.org/falm/attribute-depends-calculator) [![Coverage Status](https://coveralls.io/repos/github/falm/attribute-depends-calculator/badge.svg)](https://coveralls.io/github/falm/attribute-depends-calculator)

The scenario of the gem is when you have a attribute on model that value depends of a calculation of other model's attribute which attribute's model related. AttributeDependsCalculator will help you solve the case

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attribute-depends-calculator'
```

And then execute:

    $ bundle

## Usage
Assume you have model order and order-item
```ruby
class Order < ActiveRecord::Base
  has_many :order_items
  depends total_price: {order_items: :price}
end

class OrderItem < ActiveRecord::Base
  belongs_to :order
end
```
And you can
```ruby
order = Order.first
order.total_price
#=> 100.0
order.order_items.pluck(:price)
#=> [50.0, 50.0]
order_item = order.order_items.first
order_item.update(price: 100)
order.reload.total_price
#=> 150.0
```
As above show the price of order automatically update when whatever order_items changes

## Contributing

1. Fork it ( http://github.com/zmbacker/enum_help/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
MIT © [Falm](https://github.com/falm)
