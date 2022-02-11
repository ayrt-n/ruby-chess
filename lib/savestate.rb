# frozen_string_literal: true

require 'yaml'

# Module which allows you to save/load objects in YAML
module Savestate
  def to_yaml
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    YAML.dump(obj)
  end

  def self.from_yaml(file)
    obj = YAML.load(file)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end