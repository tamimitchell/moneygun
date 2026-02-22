# frozen_string_literal: true

require "application_system_test_case"

class DeviseAuthSystemTest < ApplicationSystemTestCase
  setup do
    page.driver.browser.manage.delete_all_cookies
  end

  test "sign in existing user" do
    user = users(:one)

    visit new_user_session_path(via_email: true)

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_no_current_path new_user_session_path
    assert_no_text "Sign in"
  end

  test "create user and sign in" do
    email = "julia@superails.com"
    password = "password"
    User.create(email:, password:, confirmed_at: Time.current)

    visit new_user_session_path(via_email: true)

    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign in"

    assert_no_current_path new_user_session_path
    assert_no_text "Sign in"
  end
end
