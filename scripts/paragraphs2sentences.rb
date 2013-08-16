require 'optparse'
require 'pathname'
require 'redis'
require 'scalpel'

Meta = Redis.new :port => 7777

opts = { from_db: 0, to_db: 0 }
OptionParser.new do |op|
  op.on("-fp [from_port]") do |v|
    opts[:from_port] = v.to_i
  end

  op.on("-fdb [from_db]") do |v|
    opts[:from_db] ||= v.to_i
  end

  op.on("-tp [to_port]") do |v|
    opts[:to_port] = v.to_i
  end

  op.on("-fdb [to_db]") do |v|
    opts[:to_db] ||= v.to_i
  end
end.parse!

$paragraphs = Redis.new :port => opts[:from_port], :db => opts[:from_db]
$sentences  = Redis.new :port => opts[:to_port],   :db => opts[:to_db]

paragraphs_ids = paragraphs.keys
paragraphs_ids.each do |paragraph_id|
  paragraph = $paragraphs.hget paragraph_id, 'string'
  sentences = Scalpel.cut paragraph

  sentences.each do |sentence|
    sentence_id = Meta.incr 'sentence-ids_counter'
    $sentences.hmset sentence_id, 'string', sentence, 'paragraph_id', paragraph_id
  end
end
