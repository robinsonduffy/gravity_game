class CreateMetaData < ActiveRecord::Migration
  def self.up
    create_table :meta_data do |t|
      t.integer :item_id
      t.string :item_type
      t.string :key
      t.text :value
      t.timestamps
    end
    add_index :meta_data, [:item_id, :item_type]
    add_index :meta_data, :key
  end

  def self.down
    drop_table :meta_data
  end
end
