require 'rspec'

require_relative "../../../../backend/app/backend/infrastructure/aggregate"

class DummyAggregate < Aggregate
  attr_reader :greeted
  def greet(whom)
    apply({type: :greeted, whom: whom})
  end

  def on_greeted(event)
    @greeted = event[:whom]
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
    CallTester.new(1).apply({type: "Something"}).called.should == "on_something"
    CallTester.new(1).apply({type: "SomeComplexType"}).called.should == "on_some_complex_type"
  end
end