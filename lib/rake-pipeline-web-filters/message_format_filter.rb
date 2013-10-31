module Rake::Pipeline::Web::Filters
  # Note this relies on the "messageformat" node module being installed
  # It's also highly specific to a certain filename convention
  class MessageFormatFilter < Rake::Pipeline::Filter

    def initialize(options={}, context = nil, &block)
      transform_filename = lambda { |input| input = self.class.normalized_filename(input) }
      super(&transform_filename)
    end

    def self.normalized_filename(name)
      name.gsub(".lang", "") # TODO, use messageformats own methods for this (overkill?)
    end

    def generate_output(inputs, output)
    # This is unfortunately coupled to our convention for these files.
    # Suggestions for improvement are welcome
    # I believe it would make sense to name these files like common.js.en.lang, or common-en.js.lan
      inputs.each do |input|
        locale = /\/lang\/([^\/]+)\//.match(input.path)[1][0,2]
        basename = File.basename(input.path)
        dir = "app/assets/" + File.dirname(input.path)
        cmd = "./node_modules/messageformat/bin/messageformat.js -l #{locale} #{dir} -I #{basename} --stdout"
        file_contents = `#{cmd}`
        output.write file_contents
      end
    end

  end
end
