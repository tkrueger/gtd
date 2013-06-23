require 'fileutils'
require 'json'

module GTD
  module Events

    class FileBackend

      def initialize(path="/tmp/streams")
        @path = path
        FileUtils.mkdir_p path unless File.exists?(path)
      end

      def save(id, events)
        File.open(stream_file(id), 'a') do |f|
          events.each {|event|
            f.write({ts: Time.now.getutc, event: event}.to_json+"\n")
          }
        end
      end

      def load_events(id)
        events = []
        File.open(stream_file(id), 'r').each_line do |line|
          parts = JSON.parse(line)
          events << parts['event']
        end
        events
      end

      def stream_file(id)
        @path + "/" + id.to_s
      end
    end

  end
end
