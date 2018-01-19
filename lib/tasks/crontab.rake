namespace :crontab do
  task :write, [:ruby_version, :root, :config, :scope] do |task, args|
    Crontab::Simple::Writer.call(
      contents: Crontab::Generator.call(
        config: Rails.application.config_for(args.config).dig('crontab', args.scope.to_s),
        root: args.root,
        env: Rails.env
      ),
      ruby_version: args.ruby_version,
      mailto: ENV['CRONTAB_SIMPLE_MAILTO'] # TODO: move to config
    )
  end

  task :mute do
    Crontab::Simple::Writer.call(
      contents: '',
      ruby_version: '',
      mailto: ''
    )
  end
end
