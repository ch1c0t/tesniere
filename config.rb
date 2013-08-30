require 'pathname'
require 'redis'

module Tesniere
  ROOT_PATH = Pathname.new('~/.tesniere').expand_path
  DB_PATH   = ROOT_PATH + 'db'

  port = 7777
  Meta  = Redis.new :port => port
end
