module Crontab
  module Simple
    class Template
      attr_reader :params

      def initialize(params)
        @params = params
        @template =
          File.read(
            File.join(
              File.dirname(__FILE__), 'template.text.erb'
            )
          )
      end

      def render
        ERB.new(@template).result binding
      end
    end
  end
end
