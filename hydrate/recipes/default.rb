execute "rake storage:production:hydrate" do
  cwd "#{node[:deploy]['playbooks_api'][:deploy_to]}/current"
  user "deploy"
  environment  ({"RAILS_ENV" => node[:deploy]['playbooks_api'][:rails_env]})
  command "/usr/local/bin/bundle exec rake storage:production:hydrate"
end