require 'test_helper'

class SignUpUserTest < ActionDispatch::IntegrationTest

  test "get user sign up form and create user" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {username: "John Doe", email: "johndoe@example.com", password: "password"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "John Doe", response.body
  end

  test "get user sign up form and reject invalid user submission" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: {username: " ", email: " ", password: " "} }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "get user sign up form and reject same email user submission" do
    User.create(username: "John Doe", email: "johndoe@example.com",
               password: "password", admin: true)
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: {username: "John Doe", email: "johndoe@example.com", password: "password"} }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
