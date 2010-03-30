require 'fileutils'
require 'net/ftp'
require 'socket'

BACKUP_DIRECTORY = Pathname.new("#{ENV['HOME']}/app_db_backups")
FileUtils.makedirs(BACKUP_DIRECTORY)

namespace :db do
  desc "Backup DB and send file to FTP account"
  #task :backup => :environment do
  task :backup do
    config = YAML.load_file(Rails.root.join('config', 'database.yml'))[Rails.env]
    #p config

    hostname = Socket.gethostname
    current_time = Time.now.to_s(:db).gsub(/\D/, '')
    backup_file_path = BACKUP_DIRECTORY.join("#{hostname}_#{current_time}" + '.bz2') 
    puts "Dumping to #{backup_file_path}"
    `pg_dump #{config['database']} -U #{config['username']} | bzip2 > #{backup_file_path}`

    puts "Uploading to FTP..."
    Net::FTP.open('ftp.mydomain.com') do |ftp|
      ftp.login('my_login', 'my_password')
      ftp.putbinaryfile(backup_file_path)
    end

  end
end

