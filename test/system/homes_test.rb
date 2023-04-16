require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url
    sleep(1)
    assert page.body.include?("111111111111")
  end
end
