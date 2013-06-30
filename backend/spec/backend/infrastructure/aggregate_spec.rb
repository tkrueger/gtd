require 'rspec'

require_relative '../../../app/backend/infrastructure/infrastructure'
require_relative '../../../app/backend/infrastructure/messaging'

include GTD::Events
include GTD::Messaging

class DummyAggregate < Aggregate
  attr_reader :greeted
  def greet(whom)
    apply(Message.new({type: :greeted, whom: whom}))
  end

  def on_greeted(event)
    @greeted = event.whom
  end

end

class CallTester < Aggregate
  attr_reader :called
  def method_missing(meth, *args, &block)
    @called = meth.to_s
  end
  def apply(type, is_new=true)
    super(type, is_new)
    self
  end
end

describe "An Aggregate" do

  it 'is instantiated using an ID' do
    DummyAggregate.new('123').should_not be_nil
    DummyAggregate.new('123').id.should == '123'
  end

  it 'uses events internally' do
    agg = DummyAggregate.new("first")
    agg.id.should == "first"
    agg.greet "me"
    agg.greeted.should == "me"
    agg.should have(1).unsaved_events
  end

  it 'converts message type to method name' do
    CallTester.new(1).apply(Message.new({type: "Something"})).called.should == "on_something"
    CallTester.new(1).apply(Message.new({type: "SomeComplexType"})).called.should == "on_some_complex_type"
  end

  it 'assigns a version to each handled event' do
    agg = DummyAggregate.new(123)
    agg.greet 'me'
    agg.greet 'mom'
    agg.unsaved_events[0].version.should == 1
    agg.unsaved_events[1].version.should == 2
  end

  it "raises version with each handled event" do
    agg = DummyAggregate.new(123)
    agg.version.should == 0
    expect { agg.greet 'me'  }.to change { agg.version }.from(0).to(1)
    expect { agg.greet 'you' }.to change { agg.version }.from(1).to(2)
  end
end
