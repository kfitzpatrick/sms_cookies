ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

require File.expand_path('../../../sms_cookies_app.rb', __FILE__)

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    SmsCookiesApp
  end

  def test_hello_monkey
    get '/'
    assert last_response.ok?
    assert_includes last_response.body, 'app should make'
  end
end