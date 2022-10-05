class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? sign_up_success : sign_up_failure(resource)
  end

  def sign_up_success
    render json: { message: 'Signed up successfully.' }, status: :ok
  end

  def sign_up_failure(resource)
    render json: {
             message: "Error signing up: #{resource.errors&.full_messages&.split("\n")&.first&.[](0)}"
           },
           status: :unprocessable_entity
  end
end
