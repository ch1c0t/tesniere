require './config'

task :install do
  unless Tesniere::DB_PATH.exist?
    FileUtils.mkdir_p Tesniere::DB_PATH
  end
end
