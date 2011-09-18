Given /^I have an \.arff file at (.*)$/ do |arg1|
  @path = File.expand_path(arg1)
end

When /^I pass it in to process$/ do
  @parser = Woof::Parser.new(@path)
end

Then /^I should get an array of hashes back$/ do
  res = @parser.parse

end

