$:.push "."
# $:.push "lib"

require 'bundler'
Bundler.require(:default)
require 'lib/decision_tree'
# require 'lib/woof'

include DecisionTree
include Woof

iris  = Parser.new('iris.arff').parse( :discretize => true )
# binding.pry

tree = ID3.new(iris, "entropy")
binding.pry
