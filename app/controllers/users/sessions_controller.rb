class Users::SessionsController < Devise::SessionsController
  include RackSessionFix

  private

  def respond_with(_resource, _opts = {})
    render json: { message: 'Logged in.', user: current_user }, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: 'Logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Error logging out.' }, status: :unauthorized
  end
end
