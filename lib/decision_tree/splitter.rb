module DecisionTree
  class Splitter

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
      return entropy
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

        #TODO: what is the [1] for? What does that mean?
        criteria_if_split_on_attribute = test_set_split.inject(0.0) do |running_total, split_dataset|
          (split_dataset[1].count.to_f / dataset[1].count.to_f) *
            self.send(split_method_name.to_sym, split_dataset[1]) +
            running_total
        end
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
