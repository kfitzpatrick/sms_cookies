require 'sinatra/base'
require 'twilio-ruby'
require './logging'

class SmsCookiesApp < Sinatra::Base
  enable :sessions
  include Logging

  get '/' do
    'The app should make a POST request to /ask-the-question.'
  end

  post '/error-occurred' do
    TerminalNotifier.notify('An error occurred!!!!')
  end


  post '/ask-the-question' do
    session[:conversation_state] ||= :unasked

    TerminalNotifier.notify("SMS received. State: #{session[:conversation_state]}")

    #TODO: smelly.  "and"????
    twilio_response = twilio_response_and_change_state(params[:From], params[:Body])
    log('Sending response to Twilio')
    twilio_response.text
  end

  #TODO: this looks independently testable

  def twilio_response_and_change_state(respondent_long_code, respondent_statement)
    application_long_code = '+14157670800'

    if session[:conversation_state] == :unasked
      session[:conversation_state] = :asked

      Twilio::TwiML::Response.new do |r|
        r.Sms({:from => application_long_code, :to => respondent_long_code},
              ['What is your favorite color?',
               "You said '#{respondent_statement}'",
               "Current state: #{session[:conversation_state].to_s}"
              ].join(" "))
      end
    else
      log "I don't know what to with the state #{session[:conversation_state]}"

      raise 'hell'
    end
  end
end

__END__

Unasked -(ask!)-> Asked -(answer!)->
Answered -(confirm!)-> Confirmed
-(reply!)-> Replied

Script

App: What is your favorite color? (ask!)

B: Blue

App: Blue? Are you sure? (Yes/No)

B: Yes

App: So you're sure about this Blue thing? Huh, that's interesting.