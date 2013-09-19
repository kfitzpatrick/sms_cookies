ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

require File.expand_path('../../../sms_cookies_app.rb', __FILE__)

include Rack::Test::Methods

def app
  SmsCookiesApp
end

describe 'GET /' do
  it 'should have some text' do
    get '/'
    assert last_response.ok?
    last_response.body.must_include 'app should make'
  end
end
