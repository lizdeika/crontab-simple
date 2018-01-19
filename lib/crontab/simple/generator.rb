module Crontab
  module Simple
    class Generator
      def self.call(config:, root:, env:)
        new(config: config, root: root, env: env).run
      end

      def initialize(config:, root:, env:)
        @config = config
        @root = root
        @env = env
      end

      def run
        return '' unless @config
        @config.map do |row|
          send row.keys[1], row['at'], row[row.keys[1].to_s]
        end.join("\n")
      end

      private

      def rails(at, what)
        "#{at} cd #{@root}/current && bin/rails #{what} RAILS_ENV=#{@env}"
      end

      def raw(at, what)
        "#{at} #{what}"
      end
    end
  end
end
