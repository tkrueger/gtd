require 'json'
require 'ostruct'

module GTD
  module Messaging
    class Message < OpenStruct
      def to_json(*)
        as_json.to_json
      end
      def as_json(*)
        klass = self.class.name
        klass.to_s.empty? and raise JSON::JSONError, "Only named structs are supported!"
        {
            JSON.create_id => klass,
            'data'         => table
        }
      end

      def self.json_create(object)
        new(object['data'] || object[:data])
      end
    end
  end
end
