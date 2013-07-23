
require_relative '../../../../backend/app/backend/infrastructure/event_stream'

class Repository

  def initialize(event_store)
    @event_store = event_store
  end

  def load(id, aggregate_type)
    aggregate_type.new(id).load_from(@event_store.load_events(id))
  end

  def save(aggregate)
    # TODO have aggregate keep a stream and append itself?
    stream = GTD::Events::EventStream.new(aggregate.id)
    aggregate.unsaved_events.each {|event| stream.append event}
    @event_store.save(aggregate.id, stream)
  end

end