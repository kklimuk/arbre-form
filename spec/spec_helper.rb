require 'bundler/setup'
require 'arbre/form'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def arbre_context(content, *args, &body)
  klass = described_class
  Arbre::Context.new { insert_tag(klass, content, *args, &body) }.to_s
end
