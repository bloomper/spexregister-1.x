set :application, "spexregister"

set :scm, :subversion
set :scm_user, ENV['scm_user'] || "anders"
set :scm_password, Proc.new { Capistrano::CLI.password_prompt("Subversion password for #{scm_user}: ") }
set :repository, Proc.new { "--username #{scm_user} --password #{scm_password} --no-auth-cache svn://192.168.4.110:3690/spexregister/spexregister.ror/trunk"} 

role :web, "bojan.spexet.chalmers.se"
role :app, "bojan.spexet.chalmers.se"
role :db,  "bojan.spexet.chalmers.se", :primary => true

set :deploy_to, "/home/users/register"
# Needed as long as the SVN repository is not accessible from bojan
set :deploy_via, :copy
set :user, "register"
set :use_sudo, true

namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  namespace :asset do
    namespace :packager do
      desc 'Create asset packages for production'
      task :build_all, :roles => :app do
        run <<-EOF
          cd #{deploy_to}/current && #{try_sudo} rake RAILS_ENV=production asset:packager:build_all
        EOF
      end
    end
  end

  namespace :sass do
    desc 'Updates the stylesheets generated by Sass'
    task :update do
      run "cd #{current_path} && #{try_sudo} rake RAILS_ENV=production sass:update"
    end
  end

  namespace :gems do
    desc "Install gems"
    task :install, :roles => :app do
      run "cd #{current_path} && #{try_sudo} rake RAILS_ENV=production gems:install"
    end
  end

  namespace :db do
    desc 'Create seeds for production'
    task :seed do
      run "cd #{current_path} && #{try_sudo} rake RAILS_ENV=production db:seed"
    end
  end

  namespace :web do
    task :disable, :roles => :web do
      # invoke with  
      # UNTIL="16:00 CET" REASON="a database upgrade" cap deploy:web:disable

      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      require 'haml'
      template = File.read('./app/views/layouts/maintenance.html.haml')
      haml_engine = Haml::Engine.new(template)

      maintenance = haml_engine.render(Object.new, :deadline => ENV['UNTIL'], :reason => ENV['REASON'])

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

after 'deploy:symlink', 'deploy:asset:packager:build_all'
before 'deploy:asset:packager:build_all', 'deploy:sass:update'
