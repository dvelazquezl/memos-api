class MemoHistoriesController < ApplicationController
  def index
    memo_histories = MemoHistory.all
    render json: memo_histories, status: :ok
  end
end
