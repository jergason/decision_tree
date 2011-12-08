$:.push "."

require 'bundler'
Bundler.require(:default)
require 'lib/decision_tree'
require 'lib/cross_validation'

def graph_tree(tree, filename)
  puts "in graph_tree"
  g = GraphViz.new(:G, :type => :digraph)
  id3_root = tree.instance_variable_get("@root")
  root = g.add_node(id3_root.label)
  recursive_graph(g, root, id3_root.children)
  puts "before_output"
  g.output(:png => filename)
end

def recursive_graph(graph, root, decision_tree_nodes)
  if decision_tree_nodes.nil?
    return
  end

  decision_tree_nodes.each do |attribute, node|
    n = graph.add_node("#{node.label}#{rand(10000)}")
    graph.add_edge(root, n, :label => attribute)
    recursive_graph(graph, n, node.children)
  end
end


iris  = Woof::Parser.new('iris.arff').parse( :discretize => true )
iris_ent = DecisionTree::ID3.new(iris.clone, split_criteria: 'entropy')
graph_tree(iris_ent, 'iris_ent.png')
iris_acc = DecisionTree::ID3.new(iris.clone, split_criteria: 'accuracy')
graph_tree(iris_acc, 'iris_acc.png')
validator = CrossValidation::Validator.new(iris.clone, DecisionTree::ID3, split_criteria: 'entropy')
puts "iris entropy: #{validator.validate(10)}"
validator = CrossValidation::Validator.new(iris, DecisionTree::ID3, split_criteria: 'accuracy')
puts "iris accuracy: #{validator.validate(10)}"

voting = Woof::Parser.new('voting.arff').parse
voting_ent = DecisionTree::ID3.new(voting.clone, split_criteria: 'entropy')
graph_tree(voting_ent, 'voting_ent.png')
voting_acc = DecisionTree::ID3.new(voting.clone, split_criteria: 'accuracy')
graph_tree(voting_acc, 'voting_acc.png')
validator = CrossValidation::Validator.new(voting.clone, DecisionTree::ID3, split_criteria: 'entropy')
puts "voting entropy: #{validator.validate(10)}"
validator = CrossValidation::Validator.new(voting.clone, DecisionTree::ID3, split_criteria: 'accuracy')
puts "voting accuracy: #{validator.validate(10)}"
