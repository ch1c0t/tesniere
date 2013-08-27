require './config'

task :default => [:install]

task :install do
  unless Tesniere::DB_PATH.exist?
    FileUtils.mkdir_p Tesniere::DB_PATH
    FileUtils.cp_r './redis-conf', Tesniere::ROOT_PATH
  end
end
