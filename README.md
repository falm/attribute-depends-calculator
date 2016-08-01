# Attribute Depends Calculator
[![Build Status](https://travis-ci.org/falm/attribute-depends-calculator.svg?branch=master)](https://travis-ci.org/falm/attribute-depends-calculator) [![Coverage Status](https://coveralls.io/repos/github/falm/attribute-depends-calculator/badge.svg?branch=master)](https://coveralls.io/github/falm/attribute-depends-calculator?branch=master) [![Code Climate](https://codeclimate.com/github/falm/attribute-depends-calculator/badges/gpa.svg)](https://codeclimate.com/github/falm/attribute-depends-calculator) [![Dependency Status](https://gemnasium.com/badges/github.com/falm/attribute-depends-calculator.svg)](https://gemnasium.com/github.com/falm/attribute-depends-calculator) [![Gem Version](https://badge.fury.io/rb/attribute-depends-calculator.svg)](https://badge.fury.io/rb/attribute-depends-calculator)

The scenario of the gem is when you have an attribute on model that value depends of a calculation of other model's attribute which attribute's model related. AttributeDependsCalculator will help you solve the case

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
  depend total_price: {order_items: :price}
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

## Advance

The options **operator** had two cateogries of value, the default value of the gem is expression **sum**

#### Operation

```ruby
class Order < ActiveRecord::Base
  has_many :order_items
  depend total_price: {order_items: :price, operator: :+} # or :*
end
```

#### Expression

The following expression can be use to calculate the collection of depends attributes

**sum**

```ruby
class Order < ActiveRecord::Base
  ...
  depend total_price: {order_items: :price, operator: :sum} # default
end
```

**average**

```ruby
class Order < ActiveRecord::Base
  ...
  depend avg_price: {order_items: :price, operator: :average}
end
```

**count**

```ruby
class Order < ActiveRecord::Base
  ...
  depend order_items_count: {order_items: :price, operator: :count}
end
```

**minimum**

```ruby
class Order < ActiveRecord::Base
  ...
  depend min_price: {order_items: :price, operator: :minimum}
end
```

**maximum**

```ruby
class Order < ActiveRecord::Base
  ...
  depend max_price: {order_items: :price, operator: :maximum}
end
```





## Contributing

1. Fork it ( http://github.com/zmbacker/enum_help/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
MIT © [Falm](https://github.com/falm)
