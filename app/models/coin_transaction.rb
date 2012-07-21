class CoinTransaction < ActiveRecord::Base
  belongs_to :user
  
  validates :transaction_type, :presence => true
  validates :note, :presence => true
  validates :amount, :presence => true,
                     :numericality => {:only_integer => true}
end
