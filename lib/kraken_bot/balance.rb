class KrakenBot

  def self.balance
    @balance||=KrakenBot::Balance.load
  end

  class Balance

    attr_accessor :value

    def initialize(value: 0)
      @value=value
    end

    def self.load
      v=50-KrakenBot::Asset.all.map{|a|a.cost}.reduce(:+)
      self.new(value: v)
    end

  end

end