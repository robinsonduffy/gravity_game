class AddBonusTimeLimitToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :bonus_time_limit, :int, :null => false, :default => 60000
  end

  def self.down
    drop_column :levels, :bonus_time_limit
  end
end
