class KrakenBot::SellingOrder < KrakenBot::Order

  def type
    "sell"
  end

  def reward
    rate*fee_multiplyer
  end

  def fee_multiplyer
    (1-SELLING_FEE/100)
  end


  def process!
    if KrakenBot.config['simulation']
      " [x] Simulate selling #{self.amount} for #{self.reward}€"
      KrakenBot.balance.value += reward
    else

    end
  end

end