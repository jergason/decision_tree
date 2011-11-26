module DecisionTree
  Node = Struct.new(:children, :label)

  class ID3
    def initialize(dataset, splitting_criteria)
      @split_criteria = splitting_criteria
      @splitter = DecisionTree::Splitter
      @dataset = dataset
    end

    def classify(feature)
      return recursive_classify(feature, @root)
    end

    def recursive_classify(feature, node)
      if node.children.nil?
        return node.label
      else
        return recursive_classify(feature, node.children[feature[node.label]])
      end
    end

    def create_tree
      @root = self.create_tree_recurse(@dataset)
    end

    def create_tree_recurse(dataset)
      # check if all samples have the same label
      if dataset.data.empty?
        #If if is empty, just pick a random one?
        return Node.new(nil, dataset.attributes[0][:nominal_attributes].sample)
      elsif dataset.all_same_label?
        # binding.pry
        return Node.new(nil, dataset.get_only_label)
      elsif not dataset.has_attributes?
        # binding.pry
        return Node.new(nil, dataset.get_most_common_label)
        # If there are no features left, return a leaf with the most common
        # class
      else
        children = dataset.split_on_attribute(@splitter.choose_attribute(dataset, @split_criteria))
        # binding.pry
        childs = {}
        children.each do |attribute_value, dataset|
          #TODO: what to do if they all split into one value? What to do about the other values? Just guess one?
          #Call a random class?
          childs[attribute_value] = self.create_tree_recurse(dataset)
        end
        return Node.new(childs, @splitter.choose_attribute(dataset, @split_criteria))
      end
    end
  end
end
