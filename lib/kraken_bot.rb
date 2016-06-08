#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require 'yaml'
require 'kraken_ruby'
require 'active_support/all'


class KrakenBot
  path=File.expand_path("../../config/config.yml",__FILE__)
  RAW_CONFIG ||= YAML::load(File.open(path))
  ENV['KRAKEN_BOT_ENV']||="development"

  def initialize(kraken_client: nil)
   @kraken= kraken_client || Kraken::Client.new(self.class.config['api_key'],self.class.config['private_key']) 
  end

  def run
    begin
      puts " [*] Started"
      loop do
        puts " [*] Current balance : #{self.class.balance.value}"
        @strategy=KrakenBot::Strategy.new(kraken_client: @kraken).action
        sleep(30)
      end
    rescue SystemExit, Interrupt => _
    end
  end

  def self.config
    RAW_CONFIG[ENV['KRAKEN_BOT_ENV']]
  end

  def self.root
    File.expand_path("../..",__FILE__)
  end
end

require 'kraken_bot/trade'
require 'kraken_bot/trades_array'
require 'kraken_bot/evolution'
require 'kraken_bot/order'
require 'kraken_bot/buying_order'
require 'kraken_bot/selling_order'
require 'kraken_bot/asset'
require 'kraken_bot/strategy'
require 'kraken_bot/balance'

Dir[File.expand_path("../../config/initializers/*.rb",__FILE__)].each {|file|require file }
