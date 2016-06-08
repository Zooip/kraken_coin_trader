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

  def process!
    if KrakenBot.config['simulation']
      " [x] Simulate buying #{self.amount} for #{self.cost}€"
      KrakenBot::Asset.create(volume: self.amount, cost: self.cost)
      KrakenBot.balance.value -= cost
    else

    end
  end

end