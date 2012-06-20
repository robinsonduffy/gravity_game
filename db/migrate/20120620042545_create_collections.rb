class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.integer :number
      t.string :name
      t.timestamps
    end
    add_index :collections, :number, :unique => true
  end

  def self.down
    drop_table :collections
  end
end
