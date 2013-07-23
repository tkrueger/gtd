require 'fileutils'
require 'json'

module GTD
  module Events

    class FileBackend

      @@stream_file = "event-stream.js"

      def initialize(path="/tmp/streams")
        @path = path
        FileUtils.mkdir_p path unless File.exists?(path)
      end

      def save(id, events)
        File.open(stream_file(), 'a') do |f|
          events.each {|event|
            f.write(
                {
                    source_id: id,
                    version: event.version,
                    ts: Time.now.getutc,
                    event: event
                }.to_json+"\n")
          }
        end
      end

      def load_events(id)
        events = []
        File.open(stream_file(), 'r').each_line do |line|
          parts = JSON.parse(line)
          events << parts['event'] if parts['source_id'] == id
        end
        events
      end

      def stream_file()
        @path + "/" + @@stream_file
      end
    end

  end
end
