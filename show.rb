#!/usr/local/bin/ruby -ws

require 'pp'
require 'parse_tree'

def discover_new_classes_from
  old_classes = []
  ObjectSpace.each_object(Module) do |klass|
    old_classes << klass
  end

  yield

  new_classes = []
  ObjectSpace.each_object(Module) do |klass|
    new_classes << klass
  end

  new_classes - old_classes
end

$f = false unless defined? $f

new_classes = discover_new_classes_from do
  ARGV.unshift "-" if ARGV.empty?
  ARGV.each do |name|
    if name == "-" then
      code = $stdin.read
      code = "class Example; def example; #{code}; end; end" if $f
      eval code unless code.nil?
    else
      require name
    end
  end
end

new_classes.each do |klass|
  pp ParseTree.new.parse_tree(klass)
end
