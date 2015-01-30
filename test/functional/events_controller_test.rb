require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get log_tour_event" do
    get :log_tour_event
    assert_response :success
  end

end
