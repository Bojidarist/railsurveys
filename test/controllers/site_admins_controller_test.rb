require 'test_helper'

class SiteAdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get admin_panel" do
    get site_admins_admin_panel_url
    assert_response :success
  end

end
