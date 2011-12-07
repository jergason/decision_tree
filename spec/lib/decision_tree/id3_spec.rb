require 'spec_helper'

describe DecisionTree::ID3 do

  let(:data) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lenses.arff'))).parse(discretize: true) }

  it "should take a dataset and a splitting criteria" do
    tree = DecisionTree::ID3.new(data, split_criteria: "entropy")
    tree.should_not be_nil
  end

  describe "#classify" do
    it "correctly classifies a certain instance" do
      # false.should be_true
    end
  end
end
