require 'json'
require 'ostruct'

module GTD
  module Messaging

    class PresenceValidator

      def initialize(attribute)
        @attribute = attribute
      end

      def validate(instance)
        unless instance.respond_to? @attribute.to_sym
          instance.errors.add(@attribute, :must_be_present)
        end
      end
    end

    class Errors

      class Error
        attr_accessor :attribute, :reason

        def initialize(attribute, reason)
          @attribute = attribute
          @reason = reason
        end

        def to_s
          "#{attribute}: #{reason}"
        end
      end

      def initialize
        @errors = []
      end

      def add(attribute, reason)
        @errors << Error.new(attribute, reason)
      end

      def empty?
        @errors.empty?
      end

      def combined_messages
        @errors.join ", "
      end
    end

    class Message < OpenStruct

      @@validators = []

      attr_reader :errors

      def initialize(hash=nil)
        super(hash)
        throw "there was an error: #{errors.combined_messages}" unless valid?
      end

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

      def validations
        # default: noop
      end

      def validates_presence_of(var)
        validate_with(PresenceValidator, var)
      end

      def validate_with(validator, attribute)
        validator.new(attribute).validate self
      end

      def valid?
        @errors = Errors.new
        validations
        errors.empty?
      end
    end
  end
end
