require 'rspec'

require_relative "../../../../backend/app/backend/domain/thought"
require_relative "../../../../backend/app/backend/infrastructure/infrastructure"

describe Thought do

  it 'should have a text' do
    thought = Thought.new(123)
    thought.captured "This is an example thought."
    thought.text.should == "This is an example thought."
    thought.should have(1).unsaved_events
  end
end