require 'json'

module JsonSerializable

  def to_json()
    hash = {}
    hash[:type] = self.class
    self.instance_variables.each do |var|
      hash[var[1..var.length]] = self.instance_variable_get(var.to_sym)
    end
    hash.to_json
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def from_json(json_string)
      hash = JSON.parse(json_string)
      instance = class_from_string(hash['type']).new
      hash.each do |var, value|
        instance.instance_variable_set "@#{var}", value unless var == 'type'
      end
      instance
    end

    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end

end