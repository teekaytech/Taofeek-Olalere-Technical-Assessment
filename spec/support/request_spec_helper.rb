module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def auth_headers
    {
      "Authorization": response.headers["Authorization"]
    }
  end

  def login_user(user)
    post "/users/sign_in", params: { user: { email: user.email, password: user.password } }
  end
end
