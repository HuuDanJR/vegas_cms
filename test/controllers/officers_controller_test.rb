require 'test_helper'

class OfficersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @officer = officers(:one)
  end

  test "should get index" do
    get officers_url
    assert_response :success
  end

  test "should get new" do
    get new_officer_url
    assert_response :success
  end

  test "should create officer" do
    assert_difference('Officer.count') do
      post officers_url, params: { officer: { date_of_birth: @officer.date_of_birth, date_of_sacrifice: @officer.date_of_sacrifice, date_revolution: @officer.date_revolution, ethnic: @officer.ethnic, gender: @officer.gender, head_of_household: @officer.head_of_household, home_town: @officer.home_town, name: @officer.name, nationality: @officer.nationality, nickname: @officer.nickname, religion: @officer.religion, status: @officer.status } }
    end

    assert_redirected_to officer_url(Officer.last)
  end

  test "should show officer" do
    get officer_url(@officer)
    assert_response :success
  end

  test "should get edit" do
    get edit_officer_url(@officer)
    assert_response :success
  end

  test "should update officer" do
    patch officer_url(@officer), params: { officer: { date_of_birth: @officer.date_of_birth, date_of_sacrifice: @officer.date_of_sacrifice, date_revolution: @officer.date_revolution, ethnic: @officer.ethnic, gender: @officer.gender, head_of_household: @officer.head_of_household, home_town: @officer.home_town, name: @officer.name, nationality: @officer.nationality, nickname: @officer.nickname, religion: @officer.religion, status: @officer.status } }
    assert_redirected_to officer_url(@officer)
  end

  test "should destroy officer" do
    assert_difference('Officer.count', -1) do
      delete officer_url(@officer)
    end

    assert_redirected_to officers_url
  end
end
