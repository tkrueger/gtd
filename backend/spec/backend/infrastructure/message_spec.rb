require 'rspec'

require_relative "../../../../backend/app/backend/infrastructure/infrastructure"

describe 'Messages' do

  it 'can be declared' do
    TestMessage1  = Class.new(GTD::Messaging::Message)
    TestMessage1.new({}).should be_a GTD::Messaging::Message
  end

  it 'can add creation checks manually' do
    TestMessage2  = Class.new(GTD::Messaging::Message) do
      def initialize(hash=nil)
        super(hash)
        throw "field xyz is mandatory" if xyz.nil?
      end
    end

    expect { TestMessage2.new(foo: "bar") }.to raise_error
    expect { TestMessage2.new(xyz: "foo") }.not_to raise_error
  end

  it 'can add creation checks declaratively' do
    TestMessage2  = Class.new(GTD::Messaging::Message) do
      def validations
        validates_presence_of :xyz
      end
    end

    expect { TestMessage2.new(foo: "bar") }.to raise_error
    expect { TestMessage2.new(xyz: "foo") }.not_to raise_error
  end
end