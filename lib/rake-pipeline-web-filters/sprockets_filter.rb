module Rake::Pipeline::Web::Filters
  require 'rake-pipeline-web-filters/filter_with_dependencies'
  # We need sprockets to parse the directive files
  class SprocketFilter < Rake::Pipeline::Filter
    include Rake::Pipeline::Web::Filters::FilterWithDependencies

    attr_reader :environment

    def self.normalized_filename(name)
      name.gsub(".coffee", "") # TODO, use sprockets own methods for this
    end

    def initialize(options={}, context = nil, &block)
      transform_filename = lambda { |input| input = self.class.normalized_filename(input) }
      super(&transform_filename)
      environment = Sprockets::Environment.new
      yield(environment)
      @environment = environment
    end


    def generate_output(inputs, output)
      inputs.each do |input|
        asset = environment[input.fullpath]
        output.write asset
      end
    end

    def external_dependencies
      [ 'sprockets' ]
    end
  end
end
