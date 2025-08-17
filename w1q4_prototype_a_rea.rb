require 'sinatra'
require 'json'
require 'puma'

class WebAppTracker
  def self.store_event(event)
    # Store event in database or data store of your choice
    # For demonstration purposes, we'll just store it in memory
    @@events ||= []
    @@events << event
  end

  def self.get_events
    @@events
  end
end

configure do
  Puma::Plugin.create do
    def start
      WebAppTracker.store_event({ type: 'app_start' })
    end
  end
end

post '/track' do
  event = JSON.parse(request.body.read)
  WebAppTracker.store_event(event)
  'Event stored!'
end

get '/events' do
  WebAppTracker.get_events.to_json
end