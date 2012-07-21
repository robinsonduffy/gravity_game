class CreateCoinTransactions < ActiveRecord::Migration
  def self.up
    create_table :coin_transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.string :transaction_type
      t.text :note
      t.timestamps
    end
    add_index :coin_transactions, :user_id
  end

  def self.down
    drop_table :coin_transactions
  end
end
