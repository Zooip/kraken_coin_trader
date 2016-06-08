class KrakenBot::Strategy

  def initialize(kraken_client: nil)
    @kraken= kraken_client || Kraken::Client.new(KrakenBot.config['api_key'],KrakenBot.config['private_key'])
    @evolution= KrakenBot::Evolution.new(kraken_client: @kraken)
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

    if variation_ratio < -0.0005
      puts " [x] Good variation for buying"
      if !cheaper_asset ||(@evolution.buying_price_prediction<(cheaper_asset.equivalent_price*0.98))
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
    KrakenBot::BuyingOrder.new(
      id:nil,
      amount: volume,
      ordered_price: price,
      status:nil,
      ).process!
    puts " [x] Buy #{volume} at #{price}"
  end

end