execute "rake storage:production:hydrate" do
  cwd "#{node[:deploy]['myapp'][:deploy_to]}/current"
  user "deploy"
  environment  ({"RAILS_ENV" => node[:deploy]['myapp'][:rails_env]})
  command "/usr/local/bin/bundle exec rake storage:production:hydrate"
end