require "application_system_test_case"

class RoulettesTest < ApplicationSystemTestCase
  setup do
    @roulette = roulettes(:one)
  end

  test "visiting the index" do
    visit roulettes_url
    assert_selector "h1", text: "Roulettes"
  end

  test "creating a Roulette" do
    visit roulettes_url
    click_on "New Roulette"

    fill_in "Description", with: @roulette.description
    fill_in "Name", with: @roulette.name
    check "Publish" if @roulette.publish
    fill_in "Streaming url", with: @roulette.streaming_url
    click_on "Create Roulette"

    assert_text "Roulette was successfully created"
    click_on "Back"
  end

  test "updating a Roulette" do
    visit roulettes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @roulette.description
    fill_in "Name", with: @roulette.name
    check "Publish" if @roulette.publish
    fill_in "Streaming url", with: @roulette.streaming_url
    click_on "Update Roulette"

    assert_text "Roulette was successfully updated"
    click_on "Back"
  end

  test "destroying a Roulette" do
    visit roulettes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Roulette was successfully destroyed"
  end
end
