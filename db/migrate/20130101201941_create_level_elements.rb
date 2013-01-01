class CreateLevelElements < ActiveRecord::Migration
  def self.up
    create_table :level_elements do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :level_elements
  end
end
