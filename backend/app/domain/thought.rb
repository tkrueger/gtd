require_relative "../../../backend/app/backend/infrastructure/aggregate"

class Thought < Aggregate

  attr_reader :text

  def captured(text)
    apply({
        type: :ThoughtCaptured,
        text: text
    })
  end

  def on_thought_captured(msg)
    @text = msg[:text]
  end

end