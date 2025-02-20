require "test_helper"

class Public::BookmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get bookmarked" do
    get public_bookmarks_bookmarked_url
    assert_response :success
  end
end
