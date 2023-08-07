require "application_system_test_case"

class OfficersTest < ApplicationSystemTestCase
  setup do
    @officer = officers(:one)
  end

  test "visiting the index" do
    visit officers_url
    assert_selector "h1", text: "Officers"
  end

  test "creating a Officer" do
    visit officers_url
    click_on "New Officer"

    fill_in "Date of birth", with: @officer.date_of_birth
    fill_in "Date of sacrifice", with: @officer.date_of_sacrifice
    fill_in "Date revolution", with: @officer.date_revolution
    fill_in "Ethnic", with: @officer.ethnic
    check "Gender" if @officer.gender
    fill_in "Head of household", with: @officer.head_of_household
    fill_in "Home town", with: @officer.home_town
    fill_in "Name", with: @officer.name
    fill_in "Nationality", with: @officer.nationality
    fill_in "Nickname", with: @officer.nickname
    fill_in "Religion", with: @officer.religion
    fill_in "Status", with: @officer.status
    click_on "Create Officer"

    assert_text "Officer was successfully created"
    click_on "Back"
  end

  test "updating a Officer" do
    visit officers_url
    click_on "Edit", match: :first

    fill_in "Date of birth", with: @officer.date_of_birth
    fill_in "Date of sacrifice", with: @officer.date_of_sacrifice
    fill_in "Date revolution", with: @officer.date_revolution
    fill_in "Ethnic", with: @officer.ethnic
    check "Gender" if @officer.gender
    fill_in "Head of household", with: @officer.head_of_household
    fill_in "Home town", with: @officer.home_town
    fill_in "Name", with: @officer.name
    fill_in "Nationality", with: @officer.nationality
    fill_in "Nickname", with: @officer.nickname
    fill_in "Religion", with: @officer.religion
    fill_in "Status", with: @officer.status
    click_on "Update Officer"

    assert_text "Officer was successfully updated"
    click_on "Back"
  end

  test "destroying a Officer" do
    visit officers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Officer was successfully destroyed"
  end
end
