class MemosController < ApplicationController
  def index
    memos = Memo.all
    render json: memos, status: :ok
  end
end
