class StatusController < ApplicationController
  def index
    render json: { status: 'API is up and running' }
  end
end
