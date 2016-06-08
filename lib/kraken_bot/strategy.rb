class KrakenBot::Strategy

  def initialize(kraken_client: nil)
    @kraken= kraken_client || Kraken::Client.new(KrakenBot.config['api_key'],KrakenBot.config['private_key'])
    @evolution= KrakenBot::Evolution.new(kraken_client: @kraken)
    puts " [*] Current balance with assets : #{KrakenBot.balance.value+KrakenBot::Asset.all.map{|a|a.volume}.reduce(:+)*@evolution.current_selling_price}"
    @evolution.print_state
    KrakenBot::Asset.print_state
  end

  def action
    process_buying
    process_sellling
  end

  protected

  def process_buying

    variation_ratio=@evolution.buying_price_variation_prediction/@evolution.current_buying_price
    cheaper_asset=KrakenBot::Asset.cheaper

    if variation_ratio < -0.0002
      puts " [x] Good variation for buying"
      if !cheaper_asset ||(@evolution.buying_price_prediction*(1+KrakenBot::BuyingOrder::BUYING_FEE*0.01)<(cheaper_asset.equivalent_price*0.995))
        buy!(@evolution.buying_price_prediction)
      end
    end
  end

  def process_sellling
    KrakenBot::Asset.all.each do |a|
      a.sell!(@evolution.selling_price_prediction) if a.should_be_sold?(@evolution.selling_price_prediction)
    end
  end


  def buy!(price)
    rate=KrakenBot.config['order_euro_rate']
    volume=rate/price
    order=KrakenBot::BuyingOrder.new(
      id:nil,
      amount: volume,
      ordered_price: price,
      status:nil,
      )
    order.process! if KrakenBot.balance.value>=order.cost
    puts " [x] Buy #{volume} at #{price}"
  end

end