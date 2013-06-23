require 'rspec'

require_relative '../../spec_helper'
require 'backend/infrastructure/messaging'

include GTD::Messaging

class ExampleMessage < GTD::Messaging::Message

end

describe 'Messages' do

  it 'should be serializable' do
    json_text = ExampleMessage.new({happened: "right now"}).to_json
    json_text.should == '{"json_class":"ExampleMessage","data":{"happened":"right now"}}'
  end

  it 'should be deserializable' do
    json_text = ExampleMessage.new({happened: "right now"}).to_json
    hydrated = JSON.parse(json_text)
    hydrated.should be_a ExampleMessage
    hydrated.happened.should == "right now"
  end

  it 'should be able to use specialized message classes' do
    class MyDerivedEvent < Message; end
    instance = MyDerivedEvent.new(extra_payload: "some data" )
    hydrated = JSON.parse(instance.to_json)
    hydrated.should be_a MyDerivedEvent
    hydrated.extra_payload.should == "some data"
  end
end


