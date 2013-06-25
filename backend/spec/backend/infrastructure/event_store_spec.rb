require 'rspec'
require 'fileutils'
require_relative '../../spec_helper'

require_relative '../../../app/backend/infrastructure/infrastructure'
require_relative '../../../app/backend/infrastructure/messaging'

include GTD::Events
include GTD::Messaging

TEST_DIR = "/tmp/test/streams"

describe 'file based event store' do

  events_wave_1 = ["event1", "event2"]
  events_wave_2 = [Message.new(some: "payload"), "event4"]

  before :all do
    FileUtils.remove_dir TEST_DIR if File.exists? TEST_DIR
  end

  before :each do
    backend = FileBackend.new(TEST_DIR)
    @store = EventStore.new(backend)
  end

  it 'should load event streams' do
    stream = EventStream.new("id")
    events_wave_1.map {|event| stream.append event}
    @store.save stream

    loaded_stream = @store.load_events("id")
    loaded_stream.should_not be_nil
    loaded_stream.events.should == events_wave_1
  end

  it 'should append to existing streams' do
    stream = EventStream.new("id2")
    stream.entity_id.should == "id2"
    events_wave_1.map {|event| stream.append event}
    @store.save stream

    stream = EventStream.new("id2")
    events_wave_2.map {|event| stream.append event}
    @store.save stream

    loaded_stream = @store.load_events("id2")
    loaded_stream.should_not be_nil
    loaded_stream.events.should == events_wave_1 + events_wave_2
  end

  it 'can give streams from a given version' do
    stream = EventStream.new("id3")
    (events_wave_1 + events_wave_2).map {|event| stream.append event}
    @store.save stream

    stream = @store.load_events("id3", from_version=3)
    stream.events.should == ["event4"]
  end
end