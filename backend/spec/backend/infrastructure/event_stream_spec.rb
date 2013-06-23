require 'rspec'

require_relative '../../spec_helper'
require 'backend/infrastructure/infrastructure'

include GTD::Events

class ExampleEvent
  attr_reader :type
  @type = "ExampleEvent"
end

describe EventStream do

  it 'raises version on appending an event' do
    stream = EventStream.new :some_id
    expect {
      stream.append(ExampleEvent.new)
    }.to change{stream.version}.from(0).to(1)
  end

  it 'remembers unsaved events' do
    stream = EventStream.new :some_id
    stream.append(ExampleEvent.new)
    stream.unsaved_events.should have_exactly(1).unsaved_event
  end

  describe 'when loaded' do
    before :each do
      @events = [ExampleEvent.new, ExampleEvent.new]
      @stream = EventStream.new(:some_id, @events)
    end

    it 'knows the current version' do
      @stream.version.should == 2
    end

    it 'does not have unsaved events' do
      @stream.unsaved_events.should be_empty
    end

    it 'can iterate over all events' do
       @stream.events.should == @events
    end
  end
end