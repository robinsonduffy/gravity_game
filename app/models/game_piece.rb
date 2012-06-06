class GamePiece < ActiveRecord::Base
  belongs_to :level
  has_many :extra_attributes
  has_many :extra_classes
  has_many :meta_data, :as => :item
  
  validates :cell, :presence => true
  validates :piece_type, :presence => true
  
  def class_hash
    class_array = Array.new
    class_array.push self.piece_type
    self.meta_data.where(:key => 'class').each do |extra_class|
      class_array.push extra_class.value
    end
    return {:class => class_array}
  end
  
  def attributes_hash
    attribute_hash = Hash.new
    attribute_hash['_cell'] = self.cell
    self.meta_data.where(['meta_data.key <> ?','class']).each do |extra_attribute|
      attribute_hash[extra_attribute.key] = extra_attribute.value
    end
    return attribute_hash
  end
end
