
namespace :db do
 
  desc "Lists unindexed foreign keys."
  task :unindexed => :environment do

    indexes = {}
    conn = ActiveRecord::Base.connection

    conn.tables.each do |table|
      indexed_columns = conn.indexes(table).map { |i| i.columns }.flatten
      conn.columns(table).each do |column|
        if column.name.match(/_id/) && !indexed_columns.include?(column.name)
          (indexes[table] ||= []) << column.name
        end
      end
    end

    indexes.each do |table, columns|
      puts columns.map { |c| "\s\sadd_index '#{table}', '#{c}'\n"}
    end

  end
end
