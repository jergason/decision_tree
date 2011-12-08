require 'spec_helper'

describe DecisionTree::ID3 do

  let(:lense_data) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lenses.arff'))).parse(discretize: true) }
  let(:test_data) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'test_set.arff'))).parse }

  # it "should take a dataset and a splitting criteria" do
  #   tree = DecisionTree::ID3.new(lense_data, split_criteria: "entropy")
  #   binding.pry
  #   tree.should_not be_nil
  # end

  # describe "#classify" do
  #   it "correctly classifies a certain instance" do
  #     tree = DecisionTree::ID3.new(lense_data, split_criteria: "entropy")
  #     tree.classify({
  #       "age" => "young",
  #       "spectacle-prescrip" => "myope",
  #       "asgitmatism" => "no",
  #       "tear-prod-rate" => "reduced",
  #       "contact-lenses" => "soft"
  #     }).should == "none"
  #   end
  # end

  describe "creation" do
    it "should create the correct tree" do
      # binding.pry
      tree = DecisionTree::ID3.new(test_data)
    end
  end
end
