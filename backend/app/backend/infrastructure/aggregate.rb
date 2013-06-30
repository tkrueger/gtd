class Aggregate

  attr_reader :unsaved_events, :id

  def initialize(id)
    @id = id
    @unsaved_events = []
  end

  def apply(event, is_new=true)
    handler = "on_#{event[:type]}".to_sym
    throw "missing event handler #{handler}" unless self.respond_to? handler
    self.send(handler.to_sym, event)
    @unsaved_events << event if is_new
  end

  def clear_unsaved_events
    @unsaved_events.clear
  end

end