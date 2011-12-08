module DecisionTree
  class Splitter

    # Return an array of new ArffFile objects
    # split on the given attribute
    # @pre-condition: attribute is a valid attribute name.
    # @param: attribute - String or Symbol - name of the attribute
    def self.split_on_attribute(dataset, attribute)
      index = find_index_of_attribute(attribute)

      splitted_stuff = {}
      dataset.attributes[index][:nominal_attributes].each do |attribute_value|
        splitted_stuff[attribute_value] = []
      end

      #then remove that attribute?
      datset.data.each do |data|
        splitted_stuff[data[attribute]] << data.clone
      end

      ret = {}
      splitted_stuff.each do |key, value|
        ret[key] = ArffFile.new(@relation_name.clone, @attributes.clone, value.clone, @class_attribute.clone).remove_attribute(attribute)
      end
      ret
    end


    def self.choose_attribute(dataset, split_criteria)
      #TODO: ignore the dang class when trying to split
      split_criteria_method_name = (split_criteria == "entropy" ? "calculate_entropy" : "calculate_accuracy")
      return self.max_gain(dataset, split_criteria_method_name)
    end

    def self.calculate_accuracy(dataset)
      counts = dataset.arrange_labels_by_count
      most_common_label = dataset.get_most_common_label
      accuracy = counts[most_common_label].to_f / dataset.count.to_f
      return accuracy
    end

    def self.calculate_entropy(dataset)
      #Entropy is just based on the class
      # binding.pry
      counts = Hash.new(0)
      dataset.each do |data|
        counts[data[dataset.class_attribute]] += 1
      end

      probs = counts.map do |key, value|
        value.to_f / dataset.count.to_f
      end

      entropy = probs.inject(0.0) do |entropy, prob|
        entropy + (-Math.log2(prob) * prob)
      end
      puts entropy
      entropy
    end

    # Return the name of the attribute splits the dataset best
    def self.max_gain(dataset, split_method_name)
      # Loop through each attribute. Calculate the entropy or accuracy
      # if the dataset were split on that attribute.
      # Return the attribute that maximizes splitting criteria

      split_criteria_values = []
      dataset.attributes.each do |attribute|
        next if attribute[:name] == dataset.class_attribute
        test_set = dataset.clone
        test_set_split = test_set.split_on_attribute attribute[:name]
        # test_set_split = split_on_attribute(test_set, attribute[:name])

        criteria_if_split_on_attribute = test_set_split.inject(0.0) do |running_total, split_dataset|
          attribute_value = split_dataset[0]
          dataset_containing_this_attribute = split_dataset[1]
          binding.pry
          (dataset_containing_this_attribute.count.to_f / dataset.count.to_f) *
            self.send(split_method_name.to_sym, dataset_containing_this_attribute) +
            running_total
        end
        binding.pry
        split_criteria_values << { attribute: attribute, split_criteria: criteria_if_split_on_attribute }
      end
      if split_method_name == "calculate_entropy"
        return split_criteria_values.sort! { |attribute1, attribute2| attribute1[:split_criteria] <=> attribute2[:split_criteria] }[0][:attribute][:name]
      elsif split_method_name == "calculate_accuracy"
        return split_criteria_values.sort! { |attribute1, attribute2| attribute1[:split_criteria] <=> attribute2[:split_criteria] }[-1][:attribute][:name]
      else
        throw "Unrecognized split criteria method name!"
      end
    end

  end
end
