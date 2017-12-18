ActiveRecord::Schema.define do

  create_table :orders do |t|
    t.decimal :price, precision: 10, scale: 2, null: false
    t.integer :count, defautl: 0
    t.timestamps null: false
  end

  create_table :order_items do |t|
    t.integer :order_id, index: true, null: false
    t.integer :product_id, index: true
    t.integer :user_id, index: true
    t.integer :quantity
    t.decimal :price, precision: 10, scale: 2, null: false
    t.timestamps null: false
  end

  create_table :products do |t|
    t.string :name
    t.decimal :price, precision: 10, scale: 2, null: false
    t.integer :sells_count, defautl: 0
    t.timestamps null: false
  end

end
