require_relative "../../../../backend/app/backend/infrastructure/aggregate"
require_relative "../infrastructure/messaging"

ThoughtCaptured = Class.new(GTD::Messaging::Message)

class Thought < Aggregate

  attr_reader :text

  def captured(text)
    apply(ThoughtCaptured.new(text: text))
  end

  def on_thought_captured(msg)
    @text = msg.text
  end

end