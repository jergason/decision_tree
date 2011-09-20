module Woof
  ARFF_ATTRIBUTE_FORMATS = ['numeric', 'integer', 'real', 'string', 'date']
  class Parser
    def initialize(file)
      @file_path = file
    end

    # Parse the relation name, the attributes, and data into 
    # Ruby data structures, and return a WoofObject
    def parse
      lines = []
      File.open(@file_path) do |f|
        lines = f.readlines
      end


      #remove comments and blank lines
      lines = lines.map do |l|
        l.chomp
      end

      lines = lines.reject do |l|
        l =~ /^\s*%.*$/s
      end

      lines = lines.reject do |l|
        l == ""
      end

      #find relation
      rel_line = lines.find do |l|
        l =~ /\s*@relation\s+\w+/i
      end
      relation_name = /^\s*@relation\s+(\w+)\s*/i.match(rel_line)[1]

      #find attributes
      attrs = lines.select do |l|
        l =~ /\s*@attribute\s+/i
      end

      #parse attributes
      parsed_attributes = []
      attrs.each do |attribute|
        matches = /^\s*@attribute\s+([\w\-]+)\s+(.*)/i.match(attribute)
        name = matches[1]
        type = matches[2]

        if !ARFF_ATTRIBUTE_FORMATS.include? type
          #assume it is a nominal kind. relational are not supported.
          type = "nominal"
          nominal_attributes = matches[2].gsub("{", "").gsub("}", "").split(",")
          nominal_attributes = nominal_attributes.map do |at|
            at.strip
          end
        end
        parsed_attribute = { name: name, type: type }
        parsed_attribute[:nominal_attributes] = nominal_attributes if defined? nominal_attributes
        parsed_attributes << parsed_attribute
      end

      #parse the @data part
      seen_data = false
      data = []
      lines.each do |l|
        if seen_data
          data_line = l.split(",")
          vals = {}
          data_line.each_with_index do |d, i|
            #TODO: what to do with "?" attributes?
            attribute = parsed_attributes[i]
            if ['numeric', 'real', 'integer'].include? attribute[:type]
              vals[attribute[:name]] = d.to_float
            elsif attribute[:type] == "string"
              vals[attribute[:name]] = d
              #it is a nominal attribute according to our naive parser
            else
              if attribute[:nominal_attributes].include? d
                vals[attribute[:name]] = d
              else
                raise "Found a nominal attribute of an incorrect type!"
              end
            end
          end
          data << vals
        elsif l =~ /\s*@data/i
          seen_data = true
        end
      end

      #look for an attribute that matches /^class$/i, or just pick the last one as the class
      class_attribute = nil
      parsed_attributes.each_with_index do |attr, i|
        class_attribute attr[:name] if attr[:name] =~ /class/i
      end
      class_attribute = parsed_attributes[-1][:name] if class_attribute.nil?

      puts "done parsing, and here is what I found"
      # p relation_name
      # p parsed_attributes
      # p data
      # p class_attribute
      arff = Woof::ArffFile.new(relation_name, parsed_attributes, data, class_attribute)
      return arff
    end
  end
end
