# Deployment server info
set :application, "SymfonyCapifony"
set :domain,      "192.168.50.4"
set :deploy_to,   "/home/vagrant/symfony"
set :app_path,    "app"
set :web_path, 	  "web"
set :maintenance_basename, 	"maintenance"

# User details for the production server
default_run_options[:pty] = true
set :user, "vagrant"
set :use_sudo, false
ssh_options[:forward_agent] = true
set :ssh_options, {:forward_agent => true, keys: ['/Users/ahdidou/.vagrant.d/insecure_private_key']}
 
# SCM info
set :repository,  "https://github.com/black1987/Symfony2CDeployement"
set :deploy_via,  :remote_cache
set :scm,         :git
 
set :model_manager, "doctrine"
 
# Role info. I don't think this is particularly important for Capifony...
role :web,        domain                         # Your HTTP server, Apache/etc
role :app,        domain                      # This may be the same as your `Web` server
role :db,         domain, :primary => true       # This is where Symfony2 migrations will run
 
set :shared_files,      ["app/config/parameters.yml"] # This stops us from having to recreate the parameters file on every deploy.
set :shared_children,   [app_path + "/logs", web_path + "/uploads", "vendor"]
set :writable_dirs, [app_path + "/cache", app_path + "/logs"]


set :use_composer, true
set	:update_vendors, true

set :clear_controllers, false

# General config stuff
set :keep_releases,  10
set :permission_method, :acl

task :upload_parameters do
  origin_file = "app/config/parameters.yml"
  destination_file = shared_path + "/app/config/parameters.yml" # Notice the
  shared_path

  try_sudo "mkdir -p #{File.dirname(destination_file)}"
  top.upload(origin_file, destination_file)
end

after "deploy:setup", "upload_parameters"

after "deploy:finalize_update" do
  run "sudo chown -R www-data:www-data #{latest_release}/#{cache_path}"
  run "sudo chown -R www-data:www-data #{latest_release}/#{log_path}"
  run "sudo chmod -R 777 #{latest_release}/#{cache_path}"
end
 
# The following line tells Capifony to deploy the last Git tag.
# Since Jenkins creates and pushes a tag following a successful build this should always be the last tested version of the code.
#set :branch, `git tag`.split("\n").last
 
# Uncomment this if you need more verbose output from Capifony
#logger.level = Logger::MAX_LEVEL
 
# Run migrations before warming the cache
#before "symfony:cache:warmup", "symfony:doctrine:migrations:migrate"
 
# Custom(ised) tasks
#namespace :deploy do
#	# Apache needs to be restarted to make sure that the APC cache is cleared.
#	# This overwrites the :restart task in the parent config which is empty.
#	desc "Restart Apache"
#	task :restart, :except => { :no_release => true }, :roles => :app do
#		run "sudo service apache2 restart"
#		puts "--> Apache successfully restarted".green
#	end
#end