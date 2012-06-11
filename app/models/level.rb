class PositiveNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "must be greater than zero" if !value.nil? && value <= 0
  end
end

class Level < ActiveRecord::Base
  has_many :game_pieces 
  has_many :completions, :dependent => :delete_all
  has_many :users_completed, :through => :completions, :source => :user
  has_many :meta_data, :as => :item, :dependent => :delete_all
  
  validates :number, :presence => true,
                     :numericality => {:only_integer => true},
                     :positive_number => true
  
  validates :grid_size, :presence => true,
                        :numericality => {:only_integer => true},
                        :inclusion => {:in => 4..8}
  
end
