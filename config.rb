require 'pathname'

module Tesniere
  ROOT_PATH = Pathname.new('~/tesniere').expand_path
  DB_PATH   = ROOT_PATH + 'db'
end
