require 'rspec'

require_relative "../../../../backend/app/backend/domain/thought"
require_relative "../../../../backend/app/backend/infrastructure/infrastructure"

describe Thought do

  it 'should have a text' do
    thought = Thought.capture 123, "This is an example thought."
    thought.id.should == 123
    thought.text.should == "This is an example thought."
    thought.should have(1).unsaved_events
  end

  it 'can be converted into an action' do
    thought = Thought.capture 123, "This is an example thought."
    thought.clear_unsaved_events
    action = thought.convert_to_action 124
    thought.should have(1).unsaved_events
  end
end