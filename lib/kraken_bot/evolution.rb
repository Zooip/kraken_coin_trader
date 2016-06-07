require 'active_support/all'

class KrakenBot::Evolution

  def initialize(kraken_client: nil)
    @kraken= kraken_client || Kraken::Client.new(KrakenBot.config['api_key'],KrakenBot.config['private_key'])
  end


  def prediction
    current_price+KrakenBot.config['target_period'].minutes*trades.slope
  end

  def current_price
    trades.between(KrakenBot.config['target_period'].minutes.ago,Time.now).mean_price
  end

  def trades
    unless @trades && @trades.last.date>30.seconds.ago
      refresh_trades
    end
    @trades
  end

  def refresh_trades
    @trades=KrakenBot::TradesArray.from_array(@kraken.trades('BTCEUR').XXBTZEUR).between(watched_period_start,Time.now)
  end

  def watched_period_start
    (KrakenBot.config['target_period']*3).minutes.ago
  end


end