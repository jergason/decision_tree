$:.push "."

require 'bundler'
Bundler.require(:default)
require 'lib/decision_tree'
require 'lib/cross_validation'


iris  = Woof::Parser.new('iris_discrete.arff').parse( :discretize => true )
# tree = DecisionTree::ID3.new(iris, split_criteria: 'entropy')
# binding.pry
validator = CrossValidation::Validator.new(iris, DecisionTree::ID3, split_criteria: 'entropy')
res = validator.validate(3)
p res
