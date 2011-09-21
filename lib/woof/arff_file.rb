module Woof
  class ArffFile
    attr_reader :relation_name, :attributes, :data, :class_attribute

    def initialize(relation_name, attributes, data, class_attribute)
      @relation_name = relation_name
      @attributes = attributes
      @data = data
      @class_attribute = class_attribute
    end

    # Return an array of new ArffFile objects
    # split on the given attribute
    # @pre-condition: attribute is a valid attribute name.
    # @param: attribute - String or Symbol - name of the attribute
    def split_on_attribute(attribute)
      index = find_index_of_attribute(attribute)

      splitted_stuff = {}
      @attributes[index][:nominal_attributes].each do |attribute_value|
        splitted_stuff[attribute_value] = []
      end

      #then remove that attribute?
      @data.each do |data|
        splitted_stuff[data[attribute]] << data.clone
      end

      ret = {}
      splitted_stuff.each do |key, value|
        ret[key] = ArffFile.new(@relation_name.clone, @attributes.clone, value.clone, @class_attribute.clone).remove_attribute(attribute)
      end
      ret
    end

    # Removes an attribute from a dataset.
    # to_remove can be an index or a String or symbol for the attribute name.
    def remove_attribute(to_remove)
      index = 0
      if not to_remove.kind_of? Fixnum
        index = find_index_of_attribute(to_remove)
      else
        index = to_remove
      end
      # binding.pry

      if not index.nil?
        @attributes.delete_at index
        @data.each do |d|
          d.delete to_remove
        end
      end
      self
    end

    def clone
      Marshal::load(Marshal.dump(self))
    end

    def each
      @data.each do |data|
        yield data
      end
    end

    def count
      @data.count
    end

    def arrange_labels_by_count
      labels = Hash.new(0)
      @data.each do |data|
        labels[data[@class_attribute]] += 1
      end
      labels
    end

    def all_same_label?
      labels = arrange_labels_by_count
      return labels.size == 1
    end

    def get_only_label
      return @data[0][@class_attribute]
    end

    def has_attributes?
      #one of the attributes is the class, so if it has more than one
      #attribute it has attributes.
      return @attributes.size > 1
    end

    def get_most_common_label
      labels = arrange_labels_by_count
      labels.sort { |h1, h2|  h1[1] <=> h2[1] }[-1][0]
    end

    def find_index_of_attribute(attribute_name)
      index = nil
      # puts "calling find_index_of_attribute"
      # puts "@attributes is #{@attributes}"
      @attributes.each_with_index do |att, i|
        index = i if att[:name] == attribute_name.to_s
      end
      index
    end
  end
end
