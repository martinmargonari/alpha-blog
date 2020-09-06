require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "John Doe", email: "johndoe@example.com",
                        password: "password")
    sign_in_as(@user)
  end

  test "get new article form and create article" do
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: {title: "Some Title", description: "Some description"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Some Title", response.body
  end

  test "get new article form and reject invalid article submission" do
    get "/articles/new"
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: {title: " ", description: " " } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
