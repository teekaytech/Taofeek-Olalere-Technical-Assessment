class HomeController < ApplicationController
  def index
    render json: { status: 200, message: 'Hello World!' }, status: :ok
  end
end
