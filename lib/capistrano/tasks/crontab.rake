def crontab_write(config, scope)
  within release_path do
    with rails_env: fetch(:stage) do
      rake "crontab:write[#{fetch(:rvm_ruby_version)},#{fetch(:deploy_to)},#{config},#{scope}]"
    end
  end
end

def crontab_mute
  within release_path do
    with rails_env: fetch(:stage) do
      rake 'crontab:mute'
    end
  end
end

namespace :crontab do
  task :write_all do
    on roles(:app_1) do
      crontab_write :crontab, :app_1
    end
  end

  task :mute_all do
    crontab_mute
  end

  task :mute_1 do
    on roles(:app_1) do
      crontab_mute
    end
  end
end

namespace :deploy do
  after 'deploy:updated',  'crontab:write_all'
  after 'deploy:reverted', 'crontab:write_all'
end
