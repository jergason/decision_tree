module DecisionTree
  Node = Struct.new(:children, :label)

  class ID3
    def initialize(dataset, options={})
      options[:split_criteria] ||= "entropy"
      @split_criteria = options[:split_criteria]
      @splitter = DecisionTree::Splitter
      @dataset = dataset
      create_tree
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

    def create_tree_recurse(dataset, parent_dataset=nil)
      #TODO: what if the dataset has no attributes and also no data?
      if dataset.all_same_label?
        return Node.new(nil, dataset.get_only_label)
      elsif not dataset.has_attributes? or dataset.count == 0
        if dataset.count == 0
          return Node.new(nil, parent_dataset.get_most_common_label)
        else
          return Node.new(nil, dataset.get_most_common_label)
        end
      else
        splitting_attribute = @splitter.choose_attribute(dataset, @split_criteria)
        children = dataset.split_on_attribute(splitting_attribute)
        childs = {}
        children.each do |attribute_value, data|
          if data.count == 0 or not dataset.has_attributes?
            childs[attribute_value] = Node.new(nil, dataset.get_most_common_label)
          else
            childs[attribute_value] = create_tree_recurse(data, dataset)
          end
        end
        return Node.new(childs, splitting_attribute)
      end
    end
  end
end
