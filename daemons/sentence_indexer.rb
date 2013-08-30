require 'ssearch'
require '../models/book_collection'

while gets
  case $_
  when /\d+:\d+/
    from, to = $_.split ':'

    book_collection = BookCollection.new :port => from
    ssearch = Ssearch.new :redis_port => to

    sentence_amount = book_collection.meta.get 'sentence_counter'
    1.upto(sentence_amount.to_i) do |id|
      sentence = book_collection.sentences.hget id, 'string'
      ssearch.add sentence, id
    end

    puts "All sentences from #{from} are indexed."
    puts "Ssearch port is #{to}."
    puts "What would you like to do next?"
  else
    puts "The command '#{$_}' does not supported by protocol."
  end
end
