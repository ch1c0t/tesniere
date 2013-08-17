require 'pathname'

module Tesniere
  ROOT_PATH = Pathname.new('~/tesniere').expand_path
  DB_PATH   = ROOT_PATH + 'db'

  Meta = Redis.new :port => 7777
end
