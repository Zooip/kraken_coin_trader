#!/usr/bin/env ruby
# encoding: utf-8

class KrakenBot::TradesArray

  attr_accessor :trades


  def initialize(trades: [])
    @trades = trades
  end

  def count
    @trades.count
  end
  alias_method :size, :count
  alias_method :length, :count

  def buy_trades
    self.class.new(trades: @trades.select{|t| t.order=="buy"})
  end

  def sell_trades
    self.class.new(trades: @trades.select{|t| t.order=="sell"})
  end

  def first
    @trades.min { |a, b| a.date <=> b.date }
  end

  def last
    @trades.max { |a, b| a.date <=> b.date }
  end

  def between(start,stop)
    self.class.new(trades: @trades.select{|t| t.date>=start && t.date<=stop})
  end

  def total_amount
    @trades.map{|t| t.amount}.reduce(:+)
  end

  def total_value
    result=@trades.map{|t| t.value}.reduce(:+)
    puts @trades unless result
    result
  end

  def mean_price
    total_value.to_f/total_amount.to_f
  end

  def median_price
    sorted=@trades.sort_by { |t| t.price}
    count % 2 == 1 ? sorted[count/2].price : (sorted[count/2 - 1].price + sorted[count/2].price).to_f / 2
  end

  def min_price
    @trades.min { |a, b| a.price <=> b.price }
  end

  def max_price
    @trades.max { |a, b| a.price <=> b.price }
  end

  def self.from_array(arr)
    self.new(trades: (arr.map{|t| KrakenBot::Trade.from_array(t)}))
  end

  def slope
    times=@trades.map{|t| t.date.to_f}
    prices=@trades.map{|t| t.price}

    mean_time= times.reduce(:+)/count

    numerator = (0...count).reduce(0) do |sum, i|
      sum + ((times[i] - mean_time) * (prices[i] - mean_price))
    end

    denominator = times.reduce(0) do |sum, x|
      sum + ((x - mean_time) ** 2)
    end

    numerator/denominator
  end


end