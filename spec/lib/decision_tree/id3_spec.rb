require 'spec_helper'

describe DecisionTree::ID3 do
  pending "DO SOME STUFF"

  it "should take a dataset and a splitting criteria" do
    tree = DecisionTree::ID3.new([], { split_criteria: "entropy"})
  end
end
