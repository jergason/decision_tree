require 'bundler'
Bundler.require(:default)

$:.push '../lib'

require 'decision_tree'
require 'cross_validation'

RSpec.configure do |conf|
  conf.color_enabled = true
end
