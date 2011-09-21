module DecisionTree
  class EntropySplitter

    def self.choose_attribute(dataset)
      #TODO: ignore the dang class when trying to split
      return self.max_entropy_gain(dataset)
    end

    def self.calculate_entropy(dataset)
      #Entropy is just based on the class
      counts = Hash.new(0)
      dataset.each do |data|
        counts[data[dataset.class_attribute]] = counts[data[dataset.class_attribute]] + 1
      end

      probs = counts.map do |key, value|
        value.to_f / dataset.count.to_f
      end

      entropy = probs.inject(0.0) do |entropy, prob|
        entropy + (-Math.log2(prob) * prob)
      end
      return entropy
    end

    # Return the name of the attribute that most decreases entropy
    # of the dataset
    def self.max_entropy_gain(dataset)
      # binding.pry
      # Loop through each attribute. Calculate the entropy gain 
      # if the dataset were split on that attribute.
      # Return the attribute that most decreases entropy

      #TODO: what the devil is this? How to make sure I am passing in a dataset?
      entropies = []
      dataset.attributes.each do |attribute|
        next if attribute[:name] == dataset.class_attribute
        test_set = dataset.clone
        test_set_split = test_set.split_on_attribute attribute[:name]

        entropy_after = test_set_split.inject(0.0) do |entropy, dataset|
          (dataset[1].count.to_f / dataset[1].count.to_f) * self.calculate_entropy(dataset[1]) + entropy
        end
        entropies << { attribute: attribute, entropy: entropy_after }
      end
      return entropies.sort! { |attribute1, attribute2| attribute1[:entropy] <=> attribute2[:entropy] }[0][:attribute][:name]
    end

  end
end
