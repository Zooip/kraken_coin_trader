class KrakenBot::BuyingOrder < KrakenBot::Order
  def type
    "buy"
  end

  def cost
    rate*fee_multiplyer
  end

  def fee_multiplyer
    (1+BUYING_FEE/100)
  end
end