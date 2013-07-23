class Aggregate

  attr_reader :unsaved_events, :id, :version

  def initialize(id)
    @version = 0
    @id = id
    @unsaved_events = []
  end

  def load_from(events)
    events.each { |event| handle(event) }
    self
  end

  def apply(event)
    event.version = @version + 1
    handle event
    @unsaved_events << event
    self
  end

  def clear_unsaved_events
    @unsaved_events.clear
  end

  private

  def handle(event)
    handler = handler_for(event).to_sym
    self.send(handler.to_sym, event)
    @version = event.version
  end

  def handler_for(event)
    # unnecessarily complex. decide on usage of dict vs. Message class
    type = event.type.nil? ? event.class.name : event.type
    type = (type.to_s.gsub /([[:upper:]]){1}/, '_\1').downcase
    "on" + (type.start_with?('_') ? type : ('_'+type))
  end

end