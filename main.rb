require 'sinatra/base'
require 'twilio-ruby'
require 'terminal-notifier'

class SmsCookiesApp < Sinatra::Base
  get '/' do
    'The app should make a POST request to /ask-the-question.'
  end

  post '/error-occurred' do
    TerminalNotifier.notify('An error occurred!!!!')
  end

  post '/ask-the-question' do
    respondent_long_code = params[:From]
    application_long_code = '+14157670800'
    puts "Respondent SMSed from #{respondent_long_code}"
    response = Twilio::TwiML::Response.new do |r|
      r.Sms({:from => application_long_code, :to => respondent_long_code},
            "What is your favorite color? You said '#{params[:Body]}'")
    end
    TerminalNotifier.notify('Response sent to Twilio')
    response.text
  end
end

__END__

Unasked -(ask!)-> Asked -(answer!)->
Answered -(confirm!)-> Confirmed
-(reply!)-> Replied

Script

App: What is your favorite color?

B: Blue

App: Blue? Are you sure? (Yes/No)

B: Yes

App: So you're sure about this Blue thing? Huh, that's interesting.