#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require 'yaml'
require 'kraken_ruby'
require 'active_support/all'


class KrakenBot
  path=File.expand_path("../../config/config.yml",__FILE__)
  RAW_CONFIG ||= YAML::load(File.open(path))
  ENV['GORG_LDAP_DAEMON_ENV']||="development"

  def initialize(kraken_client: nil)
   @kraken= kraken_client || Kraken::Client.new(self.class.config['api_key'],self.class.config['private_key'])
  end

 def run
    begin
      self.start
      puts " [*] Waiting for messages. To exit press CTRL+C"
      loop do
        sleep(1)
      end
    rescue SystemExit, Interrupt => _
      self.stop
    end
  end

  def start
    
  end

  def stop
  end

  def self.config
    RAW_CONFIG[ENV['GORG_LDAP_DAEMON_ENV']]
  end

  def self.root
    File.dirname(__FILE__)
  end
end

require 'kraken_bot/trade'
require 'kraken_bot/trades_array'
require 'kraken_bot/evolution'
require 'kraken_bot/order'
require 'kraken_bot/buying_order'

# Dir[File.expand_path("../**/*.rb",__FILE__)].each {|file| require file }
Dir[File.expand_path("../../config/initializers/*.rb",__FILE__)].each {|file|require file }
