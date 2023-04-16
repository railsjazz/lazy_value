require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url
    sleep(2)
    assert page.body.include?("4242$")
    assert page.body.include?("100%")
    assert page.body.include?("7000")
    assert page.body.include?("55₴")
    assert page.body.include?("lazy loaded from the turbo frame")
  end
end
