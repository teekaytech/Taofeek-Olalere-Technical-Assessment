require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let (:valid_attributes) do
    {
      user: {
        email: "test@test.com",
        password: "12345678"
      }
    }
  end

  let (:invalid_attributes) do
    {
      user: {
        email: "",
        password: "12345678"
      }
    }
  end

  describe "POST /users" do
    context "when the request is valid" do
      before { post "/users", params: valid_attributes }
      it "creates a user" do
        expect(json["message"]).to eq("Signed up successfully.")
        expect(response.headers["Authorization"]).to_not be_nil
        expect(response.headers["Authorization"]).to include("Bearer")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      before { post "/users", params: invalid_attributes }
      it "does not create a user" do
        expect(json["message"]).to eq("Error signing up: Email can't be blank")
        expect(response.headers["Authorization"]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /users/sign_in" do
    context "when the request is valid" do
      before do
        post "/users", params: valid_attributes
        post "/users/sign_in", params: valid_attributes
      end

      it "login a user" do
        expect(json["message"]).to eq("Logged in.")
        expect(json["user"]["email"]).to eq("test@test.com")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      before { post "/users/sign_in", params: valid_attributes }

      it "does not login a user" do
        expect(json["error"]).to eq("Invalid Email or password.")
        expect(json["message"]).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "when the request is valid" do
      before do
        post "/users", params: valid_attributes
        post "/users/sign_in", params: valid_attributes
        delete "/users/sign_out", headers: auth_headers
      end

      it "logout a user" do
        expect(json["message"]).to eq("Logged out.")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      before { delete "/users/sign_out", headers: {} }

      it "does not logout a user" do
        expect(json["message"]).to eq("Error logging out.")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
