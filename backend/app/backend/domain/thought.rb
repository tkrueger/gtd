require_relative "../../../../backend/app/backend/infrastructure/aggregate"
require_relative "../infrastructure/messaging"

ThoughtCaptured = Class.new(GTD::Messaging::Message)
ConvertedToAction = Class.new(GTD::Messaging::Message)


class Thought < Aggregate

  attr_reader :text

  def self.capture(id, text)
    thought = Thought.new(id)
    thought.captured(text)
    thought
  end

  def captured(text)
    apply(ThoughtCaptured.new(text: text))
  end

  def on_thought_captured(msg)
    @text = msg.text
  end

  def convert_to_action(action_id)
    apply(ConvertedToAction.new(action_id: action_id))
  end

  def on_converted_to_action(msg)

  end
end