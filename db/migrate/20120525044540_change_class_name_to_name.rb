class ChangeClassNameToName < ActiveRecord::Migration
  def self.up
    rename_column :extra_classes, :class_name, :name
  end

  def self.down
    rename_column :extra_classes, :name, :class_name
  end
end
