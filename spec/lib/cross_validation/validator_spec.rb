require 'spec_helper'

describe CrossValidation::Validator do
  let(:dataset) { Woof::Parser.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lenses.arff'))).parse }

  describe "#create_folds" do
    let(:validator) { CrossValidation::Validator.new(dataset, nil) }

    it "doesn't let you create more folds than the number of data items" do
      lambda {validator.create_folds(1000)}.should raise_error ArgumentError, "More folds than data"
    end

    it "returns the correct number of folds" do
      folds = validator.create_folds(10)
      folds.length.should == 10
    end

    it "creates folds that together are the original data set" do
      folds = validator.create_folds(4)
      folds[0][:test].count + folds[0][:train].count == validator.dataset.count
    end
  end

  describe "#validate" do
    let(:classifier) { DecisionTree::ID3 }
    let(:validator) { CrossValidation::Validator.new(dataset, classifier, splitting_criteria: "accuracy") }

    it "returns the accuracy of the classifier" do
      puts validator.validate(3)
    end
  end
end
