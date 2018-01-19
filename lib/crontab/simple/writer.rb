module Crontab
  module Simple
    class Writer

      COMMAND = 'crontab -'.freeze

      def self.call(contents:, ruby_version:, mailto:)
        new(contents: contents, ruby_version: ruby_version, mailto: mailto).run
      end

      def initialize(contents:, ruby_version:, mailto:)
        @contents = contents
        @ruby_version = ruby_version
        @mailto = mailto
      end

      def run
        if write
          puts '[write] crontab file written'
        else
          warn '[fail] Could not write crontab'
        end
      end

      private

      def write
        IO.popen(COMMAND, 'r+') do |crontab|
          crontab.write render
          crontab.close_write
        end

        $?.exitstatus.zero?
      end

      def render
        ::Crontab::Simple::Template.new(
          ruby_version: @ruby_version,
          mailto: @mailto,
          contents: @contents
        ).render
      end
    end
  end
end
