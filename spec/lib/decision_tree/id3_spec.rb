require 'spec_helper'

describe DecisionTree::ID3 do

  let(:lense_data) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lenses.arff'))).parse(discretize: true) }
  let(:test_data) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'test_set.arff'))).parse }

  it "should take a dataset and a splitting criteria" do
    tree = DecisionTree::ID3.new(lense_data, split_criteria: "entropy")
    tree.should_not be_nil
  end

  describe "#classify" do
    it "correctly classifies a certain instance" do
      tree = DecisionTree::ID3.new(lense_data, split_criteria: "entropy")
      tree.classify({
        "age" => "young",
        "spectacle-prescrip" => "myope",
        "asgitmatism" => "no",
        "tear-prod-rate" => "reduced",
        "contact-lenses" => "soft"
      }).should == "none"
    end
  end

  describe "creation" do
    def recursive_check(node, class_attributes)
      if node.children.nil?
        class_attributes.include?(node.label).should be_true
      else
        node.children.each do |attribute, child_node|
          recursive_check(child_node, class_attributes)
        end
      end
    end

    it "creates a tree with only class values as the attributes" do
      tree = DecisionTree::ID3.new(test_data)
      root = tree.instance_variable_get("@root")
      recursive_check(root, test_data.get_class_values)
    end

    it "allows use of accuracy instead of entropy as the splitting criteria" do
      tree = DecisionTree::ID3.new(lense_data, split_criteria: "accuracy")
      binding.pry
      tree.should_not be_nil
    end
  end
end
