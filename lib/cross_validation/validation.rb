module CrossValidation
  # N-fold Cross-validation Method
  # Partition dataset (call it D) into N equally-sized subsets S1, ..., SN
  # For k = 1 to N
  # Let Mk be the model induced from D - Sk
  # Let nk be the number of instances of Sk correctly classified by Mk
  # Return (n1+n2+...+nN)/N
  class Validator
    attr_reader :dataset
    def initialize(dataset, classifier, classifier_args={})
      @dataset = dataset
      @classifier = classifier
      @classifier_args = classifier_args
    end

    def create_folds(n)
      raise ArgumentError.new("More folds than data") if n > @dataset.length
      @folds = []
      removal_size = @dataset.length / n
      (n-1).times do |i|
        test_set = @dataset[i*removal_size..(i+1)*removal_size]
        train_set = @dataset - test_set
        @folds << {
          test: test_set,
          train: train_set
        }
      end
      test_set = @dataset[(n-1)*removal_size...-1]
      train_set = @dataset - test_set
      @folds << {
        test: test_set,
        train: train_set
      }
      @folds
    end

    def validate(number_of_folds)
      create_folds number_of_folds
      number_correct = 0
      number_wrong = 0
      @folds.each do |fold|
        model = @classifier.new(fold[:train], @classifier_args)
        # binding.pry
        fold[:test].each do |test|
          predicted_class = model.classify(test)
          if test[fold[:test].class_attribute] == predicted_class
            number_correct += 1
          else
            number_wrong += 1
          end
        end
      end
      {
        accuracy: number_correct.to_f / (number_wrong.to_f +  number_correct.to_f),
        number_correct: number_correct,
        number_wrong: number_wrong
      }
    end
  end
end
