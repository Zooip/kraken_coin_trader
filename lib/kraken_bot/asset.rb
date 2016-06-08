require 'active_record'

class KrakenBot::Asset < ActiveRecord::Base

  def equivalent_price
    self.cost.to_f/self.volume.to_f
  end

  def expected_selling_price
    equivalent_price*(1+KrakenBot.config['desired_margin']*0.01)
  end

  def should_be_sold?(predicted_selling_price)
    reward=generate_order(predicted_selling_price).equivalent_price

    #puts "[x] Evaluate profit of Asset n°#{id} : R=#{reward} Exp=#{expected_selling_price}"
    expected_selling_price <= reward
  end

  def sell!(price=expected_selling_price)
    puts " [x] Selling asset n°#{self.id} !"
    generate_order(price).process!
    self.destroy
  end

  def generate_order(price)
    KrakenBot::SellingOrder.new(
      id:nil,
      amount: self.volume,
      ordered_price: price,
      status:nil,
      )
  end


  def self.cheaper
    self.all.min{|a,b| a.equivalent_price <=> b.equivalent_price}
  end

  def self.print_state
    puts   "___________________________________________________________"
    puts   "|   Id | Volume     |       Cost |  Buy Price |  Exp. Pric.|"
    puts   "|______|____________|____________|____________|____________|"
    self.all.each do | a|
      printf("| %#4d | %#2.8f | %10.6f | %10.6f | %10.6f |\n",a.id,a.volume, a.cost,a.equivalent_price, a.expected_selling_price)
    end
    puts   "|______|____________|____________|____________|____________|"
    puts
  end

  def self.kraken
    @kraken||=Kraken::Client.new(KrakenBot.config['api_key'],KrakenBot.config['private_key'])
  end

  def self.kraken= kraken_client
    @kraken=kraken_client
  end
 
end