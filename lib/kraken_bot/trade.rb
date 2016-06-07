#!/usr/bin/env ruby
# encoding: utf-8

class KrakenBot::Trade

  attr_accessor :date
  attr_accessor :price
  attr_accessor :amount
  attr_accessor :order
  attr_accessor :type


  def initialize(date: nil, price:nil, amount: nil, order:nil, type:nil)
    @date=date
    @price=price
    @amount=amount
    @order=order
    @type=type
  end

  def value
    @price * @amount
  end

  def self.from_array(arr)
    self.new(
        price: arr[0].to_f,
        amount: arr[1].to_f,
        date: Time.at(arr[2]),
        order: arr[3] == "s" ? "sell" : "buy",
        type: arr[3] == "m" ? "market" : "limit",
      )
  end
end