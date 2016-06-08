require 'active_support/all'

class KrakenBot::Evolution

  def initialize(kraken_client: nil)
    @kraken= kraken_client || Kraken::Client.new(KrakenBot.config['api_key'],KrakenBot.config['private_key'])
  end

  def price_prediction(set=trades)
    current_price+price_variation_prediction(set)
  end

  def buying_price_prediction
    price_prediction(trades.buy_trades)
  end

  def selling_price_prediction
    price_prediction(trades.sell_trades)
  end

  def price_variation_prediction(set=trades)
    KrakenBot.config['target_period'].minutes*set.slope
  end

  def buying_price_variation_prediction
    price_variation_prediction(trades.buy_trades)
  end

  def selling_price_variation_prediction
    price_variation_prediction(trades.sell_trades)
  end



  def current_price(set=recent_trades)
    set.mean_price
  end

  def current_buying_price
    current_price(recent_trades.buy_trades)
  end

  def current_selling_price
    current_price(recent_trades.sell_trades)
  end

  def print_state

    refresh_trades
    puts   "__________________________________________________"
    printf("| Prices     | %10s | %10s | %10s |\n","Mean","Buying","Selling")
    puts   "|____________|____________|____________|____________|"
    printf("| Current    | %4.6f | %4.6f | %4.6f |\n",current_price,current_buying_price,current_selling_price)
    printf("| Prediction | %4.6f | %4.6f | %4.6f |\n",price_prediction,buying_price_prediction,selling_price_prediction)
    printf("| Variation  | %+2.7f | %+2.7f | %+2.7f |\n",price_variation_prediction,buying_price_variation_prediction,selling_price_variation_prediction)
    printf("| Percent    | %+2.5f %% | %+2.5f %% | %+2.5f %% |\n",price_variation_prediction*100/current_price,buying_price_variation_prediction*100/current_buying_price,selling_price_variation_prediction*100/current_selling_price)
    puts   "|____________|____________|____________|____________|"
    puts
  end



  protected
    def trades
      unless @trades && @refreshed_time && @refreshed_time>30.seconds.ago
        refresh_trades
      end
      @trades
    end

    def refresh_trades
      puts " [*] Refresh public trades list"
      @trades=KrakenBot::TradesArray.from_array(@kraken.trades('BTCEUR').XXBTZEUR).between(tendency_period_start,Time.now)
      @refreshed_time=Time.now
      puts " [*] Number of trades = #{@trades.count} (B= #{@trades.buy_trades.count};S= #{@trades.sell_trades.count})"
      puts " [*] Firsts B=#{@trades.buy_trades.first.date.to_s}  S=#{@trades.sell_trades.first.date.to_s}"
      puts " [*] Lasts  B=#{@trades.buy_trades.last.date.to_s}  S=#{@trades.sell_trades.last.date.to_s}"
    end

    def recent_trades
      trades.between(watched_period_start,Time.now)
    end

    def tendency_period_start
      (KrakenBot.config['target_period']*3).minutes.ago
    end

    def watched_period_start
      (KrakenBot.config['target_period']).minutes.ago
    end
end