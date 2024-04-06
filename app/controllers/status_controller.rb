class StatusController < ApplicationController
  def index
    git_commit_hash = `git rev-parse --short HEAD`.strip
    render json: { status: 'API is up and running', commit: git_commit_hash }, status: :ok
  end
end
