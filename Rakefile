require 'pathname'
require 'redis'
require 'scalpel'

require './config'

task :default => [:install]

task :install do
  unless Tesniere::DB_PATH.exist?
    FileUtils.mkdir_p Tesniere::DB_PATH
  end
end

task :save_paragraphs do
  file = Pathname.new ENV['file']
  port = ENV['port']
  db   = ENV['db'] || 0

  r = Redis.new :port => port, :db => db 

  if file.exist?
    text = IO.read file
    paragraphs = text
      .split(/\r\n\r\n/)
      .delete_if &:empty?

    book_start = paragraphs.find_index { |s| s.start_with? '*** START' }
    book_end   = paragraphs.find_index { |s| s.start_with? '*** END' }

    paragraphs = paragraphs[book_start+1...book_end]
    paragraphs.each_with_index do |paragraph, index|
      r.hset index, 'string', paragraph
    end
  else
    p "Thou shall specify a correct path to file."
  end
end

task :save_sentences do
  fport = ENV['fport']
  fdb   = ENV['fdb'] || 0
  tport = ENV['tport']
  tdb   = ENV['tdb'] || 0
  
  from = Redis.new :port => fport, :db => fdb
  to   = Redis.new :port => tport, :db => tdb

  paragraphs_ids = from.keys
  paragraphs_ids.each do |paragraph_id|
    paragraph = from.hget paragraph_id, 'string'
    sentences = Scalpel.cut paragraph

    sentences.each do |sentence|
      sentence_id = Tesniere::Meta.incr 'sentence-ids_counter'
      to.hmset sentence_id, 'string', sentence, 'paragraph_id', paragraph_id
    end
  end
end
