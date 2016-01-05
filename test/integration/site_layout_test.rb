require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links for guests" do
    get root_path
    assert_template 'store/index'
    assert_select "a[href=?]", root_path, count: 4
  end
end
