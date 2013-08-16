require 'optparse'
require 'pathname'
require 'redis'

opts = { db: 0 }
OptionParser.new do |op|
  op.on("-p [redis_port]") do |v|
    opts[:port] = v.to_i
  end

  op.on("-n [redis_db]") do |v|
    opts[:db] ||= v.to_i
  end

  op.on("-f [file]") do |v|
    opts[:file] = Pathname.new v
  end
end.parse!

if opts[:file].exist?
  text = IO.read opts[:file]
  paragraphs = text
    .split(/\r\n\r\n/)
    .delete_if &:empty?

  book_start = paragraphs.find_index { |s| s.start_with? '*** START' }
  book_end   = paragraphs.find_index { |s| s.start_with? '*** END' }

  #metainfo = parse_metainfo_from paragraphs[0..book_start]
  paragraphs = paragraphs[book_start+1...book_end]
  
  r = Redis.new :port => opts[:port], :db => opts[:db]
  #metainfo.each { |key, value| r.set key, value }
  paragraphs.each_with_index do |paragraph, index|
    r.hset index, 'string', paragraph
  end
else
  p "Thou shall specify a correct path."
end

def parse_metainfo_from array
  metainfo = {}
  array.each do |string|
    key, value = string.split ': ', 2
    metainfo[key] = value unless key.nil? || value.nil?
  end

  metainfo
end
