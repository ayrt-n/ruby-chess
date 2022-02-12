# frozen_string_literal: true

require 'yaml'

# Module which allows you to save/load objects in YAML
class Savestate
  attr_reader :dirname

  def initialize(dirname = 'savestates')
    @dirname = dirname
  end

  def mkdir
    Dirmkdir(dirname) unless File.exist?(dirname)
  end

  def create_savestate(raw_obj)
    filename = Time.now.strftime("%m-%d_%H-%M-%S")
    mkdir
    File.open("#{dirname}/#{filename}.yaml", 'w') { |f| f.write(to_yaml(raw_obj)) }
  end

  def to_yaml(obj)
    YAML.dump(obj)
  end

  def from_yaml(file)
    YAML.load(file)
  end
end