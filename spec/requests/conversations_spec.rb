ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require 'nokogiri'

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

describe 'receiving text messages from users' do

  describe 'the first time' do
    it 'TwiML response with a text back which asks your favorite color' do
      users_long_code = '+5555551212'
      post '/ask-the-question', :From => users_long_code, :Body => 'abc'
      assert last_response.ok?
      response_xml = Nokogiri::XML(last_response.body)
      sms = response_xml.css('Response Sms').first
      sms.text.must_include 'What is your favorite color?'
      sms.attr('to').must_equal users_long_code
    end
  end

end

