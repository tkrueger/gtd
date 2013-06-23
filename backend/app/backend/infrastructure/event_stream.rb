module GTD
  module Events

    class EventStream
      attr_reader :entity_id, :version, :unsaved_events, :events

      def initialize(entity_id, events=[])
        @version = 0
        @unsaved_events = []
        @events = events
        @version = events.size
        @entity_id = entity_id
      end

      def append event
        @unsaved_events << event
        @version += 1
      end

    end
  end
end
