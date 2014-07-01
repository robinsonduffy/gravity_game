class CoinTransactionsController < ApplicationController
  before_filter :require_current_user
  
  def show
    @coin_transactions = current_user.coin_transactions.order('created_at DESC')
  end
end
