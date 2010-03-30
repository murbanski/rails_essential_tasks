

namespace :app do

  desc "Restart application server"
  task :restart do
    FileUtils.touch( Rails.root.join *%w{tmp restart.txt} )
    puts "RESTART #{Time.now}"
  end


  desc "Application redeploy- RUN THIS ON SERVER!!!"
  task :redeploy do
    puts `cd #{Rails.root} && git pull`
    Rake::Task["db:migrate"].invoke
    Rake::Task["app:restart"].invoke

    %w{public/javascripts/all.js public/stylesheets/all.css}.each do |cache_file|
      File.unlink(Rails.root+cache_file) if File.exists?(Rails.root+cache_file)
    end
  end

end
