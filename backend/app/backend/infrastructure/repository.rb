
class Repository

  def initialize(event_store)
    @event_store = event_store
  end

  def load(id, aggregate_type)
    aggregate = aggregate_type.new(id)
    @event_store.load_events(id).each { |msg| aggregate.apply(msg, false) }
    return aggregate
  end

end