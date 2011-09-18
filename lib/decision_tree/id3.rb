module DecisionTree
  class ID3
    def initialize(dataset, splitting_criteria)
      if splitting_criteria == "entropy"
        @splitter = DecisionTree::EntropySplitter
      elsif splitting_criteria == "accuracy"
        @splitter = DecisionTree::AccuracySplitter
      end
      @dataset = dataset
    end

    def create_tree
      root_attribute = @splitter.choose_attribute(dataset)

    end

  end
end
