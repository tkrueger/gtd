require 'sinatra'
require 'thin'
require 'json'
require 'uuid'
require_relative '../../../backend/app/backend/domain/thought'
require_relative '../../../backend/app/backend/infrastructure/event_store'
require_relative '../../../backend/app/backend/infrastructure/file_backend'
require_relative '../../../backend/app/backend/infrastructure/repository'

def run(opts)
  # define some defaults for our app
  server    = opts[:server] || 'thin'
  host      = opts[:host]   || '0.0.0.0'
  port      = opts[:port]   || '8181'
  rest_port = opts[:rest_port_app]
  web_app   = opts[:web_app]

  dispatch = Rack::Builder.app do

    map '/api' do
      run rest_port
    end

    map '/gtd' do
      run web_app
    end

  end


  puts File.dirname(__FILE__) + '/../../public'
  Rack::Server.start({
                         app:    dispatch,
                         server: server,
                         Host:   host,
                         Port:   port
                     })
end

class MyCustomError < RuntimeError

end

class HelloApp < Sinatra::Base

  set :backend, GTD::Events::FileBackend.new("/tmp/event_x")
  set :event_store, GTD::Events::EventStore.new(backend)
  set :repository, Repository.new(event_store)

  configure do
    set :threaded, false
  end

  before do
    content_type 'application/json'
  end

  error 403 do
    'Access forbidden'
  end

  get "/thoughts" do
    #JSON.generate({
    #                  :text => "some text"
    #              })
  end

  post "/thoughts" do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    "Creating new thought from '#{data['text']}'!\n"
    uuid = UUID.new
    thought = Thought.new(uuid)
    thought.captured(data['text'])
    settings.repository.save(thought)

    JSON.generate({
        :created => uuid.generate(format=:compactd ),
        :links => {
            :rel => :self,
            :uri => "http://localhost:8181/thoughts/#{uuid}"
        }
    })
  end
end

class WebApp < Sinatra::Base


  set :public_folder, File.dirname(__FILE__) + '/../../public'

  get "/thoughts/capture" do
    haml :capture_thoughts, :att_wrapper => '"', :locals => { :msg => 'hi there' }
  end
end

run rest_port_app: HelloApp.new, web_app: WebApp.new