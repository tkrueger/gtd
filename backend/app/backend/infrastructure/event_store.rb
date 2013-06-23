module GTD
  module Events
    class EventStore

      def initialize(backend)
        @backend = backend
      end

      def save(stream)
        @backend.save(stream.entity_id, stream.unsaved_events)
      end

      def load_events(id)
        EventStream.new(id, @backend.load_events(id))
      end
    end
  end
end
