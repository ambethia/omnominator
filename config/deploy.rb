set  :application,           "omnominator"
set  :repository,            "git@github.com:ambethia/omnominator.git"
set  :branch,                "release"
set  :scm,                   :git
set  :git_enable_submodules, true
set  :deploy_via,            :remote_cache
role :web,                   "omnom"
role :app,                   "omnom"
role :db,                    "omnom", :primary => true

ssh_options[:forward_agent] = true

namespace :deploy do
  task :custom_symlinks do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/action_mailer.yml #{release_path}/config/action_mailer.yml"
  end

  desc "Restart Passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with Passenger"
    task t, :roles => :app do ; end
  end
end

before "deploy:migrate", "deploy:custom_symlinks"
after  "deploy:symlink", "deploy:custom_symlinks"
after  "deploy",         "deploy:cleanup"
