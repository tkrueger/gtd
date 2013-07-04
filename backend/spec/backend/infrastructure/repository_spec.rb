require 'rspec'

require_relative "../../../../backend/app/backend/infrastructure/infrastructure"

include GTD::Messaging

class DummyAggregate < Aggregate
  attr_reader :greeted, :greeted_by
  def greet(whom)
    apply(Message.new({type: :greeted, whom: whom}))
  end

  def greeted_back(by_whom)
    apply(Message.new({type: :greeted_back, by_whom: by_whom}))
  end

  def on_greeted(event)
    @greeted = event.whom
  end

  def on_greeted_back(event)
    @greeted_by = event.by_whom
  end

end

class MockEventStore
  attr_accessor :events
  def initialize
    @events = {}
  end
  def load_events(id)
    return @events[id] || []
  end
end

describe "An Aggregate" do

  before :each do
    @event_store = MockEventStore.new
    @repository = Repository.new @event_store

    @event_store.events['123'] = [
        Message.new({type: :greeted, whom: 'me'}),
        Message.new({type: :greeted_back, by_whom: 'Thorsten'})
    ]
    @loaded = @repository.load('123', DummyAggregate)
  end

  it 'is requested by ID' do
    @loaded.should_not be_nil
  end

  it 'has events replayed upon loading' do
    @loaded.greeted.should == 'me'
    @loaded.greeted_by.should == 'Thorsten'
  end

  it 'has no unsaved events' do
    @loaded.should have(0).unsaved_events
  end

end