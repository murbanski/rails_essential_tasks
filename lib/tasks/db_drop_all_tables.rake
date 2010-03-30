
namespace :db do
  desc "Drop all tables when you can't delete and create whole DB"
  task :drop_all_tables => :environment do
    ActiveRecord::Base.connection.tables.each do |table| 
      puts "Dropping #{table}"
      ActiveRecord::Base.connection.execute "DROP TABLE #{table} CASCADE"
    end
  end
end

