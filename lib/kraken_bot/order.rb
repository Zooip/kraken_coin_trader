require 'active_support/all'

class KrakenBot::Order

  BUYING_FEE=0.16
  SELLING_FEE=0.26

  attr_accessor :id
  attr_accessor :amount
  attr_accessor :ordered_price
  attr_accessor :price
  attr_accessor :status

  def initialize(id:nil, amount: nil, ordered_price: nil, price: nil, status:nil)
    @id=id
    @amount=amount
    @ordered_price=ordered_price
    @price=price
    @status=status
  end

  def rate
    @amount*(@price||@ordered_price)
  end

end