module DecisionTree
  Node = Struct.new(:children, :label)

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
      root_attribute = @splitter.choose_attribute(@dataset)
      @root = self.create_tree_recurse(@dataset)
    end

    def classify(feature)
      #start at root
      return recursive_classify(feature, @root)
    end

    def recursive_classify(feature, node)
      if node.children.nil?
        return node.label
      else
        return recursive_classify(feature, node.children[feature[node.label]])
      end
    end

    def create_tree_rescurse(dataset)
      # check if all samples have the same label
      if dataset.same_label?
        return Node.new(nil, dataset.get_same_label)
      elsif not dataset.has_attributes?
        return Node.new(nil, dataset.get_most_common_label)
        # If there are no features left, return a leaf with the most common
        # class
      else
        children = dataset.split_on_attribute(@splitter.choose_attribute(dataset))
        childs = {}
        children.each do |attribute_value, dataset|
          childs[attribute_value] = create_tree_rescurse(dataset)
        end
        return Node.new(childs, @splitter.choose_attribute(dataset))
      end
    end
  end
end
