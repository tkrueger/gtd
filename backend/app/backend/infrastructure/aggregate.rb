class Aggregate

  attr_reader :unsaved_events, :id, :version

  def initialize(id)
    @version = 0
    @id = id
    @unsaved_events = []
  end

  # TODO split loading from old and handling new events
  def apply(event, is_new=true)
    if is_new
      event.version = @version + 1
    end
    handler = handler_for(event.type).to_sym
    self.send(handler.to_sym, event)
    @unsaved_events << event if is_new
    @version = event.version
  end

  def handler_for(event_type)
    type = (event_type.to_s.gsub /([[:upper:]]){1}/, '_\1').downcase
    "on" + (type.start_with?('_') ? type : '_' + type)
  end

  def clear_unsaved_events
    @unsaved_events.clear
  end

end