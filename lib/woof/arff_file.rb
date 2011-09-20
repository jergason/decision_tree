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

      splitted_stuff = Hash.new([])
      @attributes[index][:nominal_attributes].each do |attribute_value|
        splitted_stuff[attribute_value] = []
      end

      #then remove that attribute?
      @data.each do |data|
        splitted_stuff[data[attribute]] << data.clone
      end

      binding.pry
      ret = {}
      splitted_stuff.each do |key, value|
        ret[key] = ArffFile.new(@relation_name, @attributes, value, @class_attribute).remove_attribute(attribute)
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

      if not index.nil?
        @attributes.delete_at index
        @data.each do |d|
          d.delete_at index
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
