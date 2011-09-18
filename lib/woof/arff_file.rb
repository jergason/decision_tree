module Woof
  class ArffFile
    attr_reader :relation_name, :attributes, :data

    def initialze(relation_name, attributes, data)
      @relation_name = relation_name
      @attributes = attributes
      @data = data
    end

    # Return an array of new ArffFile objects
    # split on the given attribute
    # @pre-condition: attribute is a valid attribute name.
    # @param: attribute - String or Symbol - name of the attribute
    def split_on_attribute(attribute)
      index = find_index_of_attribute(attribute)
      #Make a hash with a slot for each value of the attribute?
      splitted_stuff = {}
      @attributes[index][:nominal_attributes].each do |attribute_value|
        splitted_stuff[attribute_value] = []
      end

      #then remove that attribute?
      @data.each do |data|
        splitted_stuff[data[index]] << data.clone
      end

      return splitted_stuff.map do |key, value|
        ArffFile.new(@relation_name, @attribute, value).remove_attribute(attribute)
      end
    end

    # Removes an attribute from a dataset.
    # to_remove can be an index or a String or symbol for the attribute name.
    def remove_attribute(to_remove)
      index = 0
      if not to_remove.kind_of? FixNum
        index = find_index_of_attribute(to_remove)
      else
        index = to_remove
      end

      @attributes.delete_at index
      @data.each do |d|
        d.delete_at index
      end
    end

    def clone
      Marshal::load(Marshal.dump(self))
    end

    def each
      @data.each do |data|
        yield data
      end
    end

    private
    def find_index_of_attribute(attribute_name)
      index = nil
      @attributes.each_with_index do |att, i|
        index = i if att[:name] == attribute_name.to_s
      end
      index
    end
  end
end
