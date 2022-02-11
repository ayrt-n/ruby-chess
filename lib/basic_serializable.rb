# frozen_string_literal: true

require 'yaml'

# Basic module to serialize class
module BasicSerializable
  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    YAML.dump(obj)
  end

  def unserialize(string)
    obj = YAML.parse(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end

  def save_object
    dir_name = 'savestates'
    print 'New file name: '
    filename = gets.chomp
    puts ''
    Dirmkdir(dirname) unless File.exist?(dirname)
    File.open("#{dirname}/#{filename}.yaml", 'w') { |f| f.write(serialize) }
  end
end
