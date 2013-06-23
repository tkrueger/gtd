require 'rspec'

require_relative '../../spec_helper'
require_relative '../../../app/backend/infrastructure/json_serializable'

class SomeClass
  include JsonSerializable
  attr_reader :a,:b
  def initialize(a=0,b=0)
    @a = a
    @b = b
  end

  def == other
    other.a == @a && other.b == @b
  end
end

class SomeComplexClass
  include JsonSerializable
  attr_reader :my_list

  def append(text)
    @my_list ||= []
    @my_list << text
  end

end


describe 'Serialization' do

  it 'should serialize all instance variables' do
    SomeClass.new(1,2).to_json.should == '{"type":"SomeClass","a":1,"b":2}'
  end

  it 'should also handle complex objects' do
    instance = SomeComplexClass.new
    instance.append "this"
    instance.append "this, too"
    instance.to_json.should == '{"type":"SomeComplexClass","my_list":["this","this, too"]}'
  end

end

describe 'Deserialization' do

  it 'should deserialize all instance variables' do
    SomeClass.from_json(SomeClass.new(1,2).to_json).should == SomeClass.new(1,2)
  end

end