class RemovePieceTypeFromLevelElement < ActiveRecord::Migration
  def self.up
    remove_column :level_elements, :piece_type
  end

  def self.down
  end
end
