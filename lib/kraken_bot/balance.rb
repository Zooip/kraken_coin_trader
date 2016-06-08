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
      self.new(value: 50)
    end

  end

end