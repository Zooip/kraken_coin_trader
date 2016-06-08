#001_create_assets_table.rb
require_relative '../../lib/kraken_bot.rb'

class CreateAssetsTable < ActiveRecord::Migration

  def up
    create_table :assets do |t|
      t.float :volume
      t.float :cost

      t.timestamps null: false
    end
    puts 'ran up method'
  end 

  def down
    drop_table :assets
    puts 'ran down method'
  end

end

CreateAssetsTable.migrate(ARGV[0])