
class Repository

  def initialize(event_store)
    @event_store = event_store
  end

  def load(id, aggregate_type)
    aggregate_type.new(id).load_from(@event_store.load_events(id))
  end

end