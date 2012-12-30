class CreateCoinCosts < ActiveRecord::Migration
  def self.up
    create_table :coin_costs do |t|
      t.integer :item_id
      t.string :item_type
      t.integer :value

      t.timestamps
    end
    add_index :coin_costs, [:item_id, :item_type]
  end

  def self.down
    drop_table :coin_costs
  end
end
