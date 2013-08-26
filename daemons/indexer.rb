require 'pathname'
require 'gutenberg/book'
require 'ssearch'
require 'redis'

require '../config'

class BookStore < Array
  def initialize args = {}
    port = args[:port]

    store = Redis.new :port => port
    store_meta = Redis.new :port => port, :db => 1

    super [store, store_meta]
  end
end

while gets
  case $_
  when /^(status|s)/
    puts 'Status is not implemented yet.'
  when /\d+:\d+:./
    store_port, ssearch_port, directory = $_.split ':'

    store, store_meta = BookStore.new :port => store_port
    ssearch = Ssearch.new :redis_port => ssearch_port

    Pathname.glob("#{directory.strip}/*.txt").each do |file|
      book = Gutenberg::Book.new file
      book_id = Tesniere::Meta.incr 'book-ids_counter'

      book.paragraphs.each do |paragraph|
        paragraph_id = store_meta.incr 'paragraph-ids_counter'
        store.hmset paragraph_id, 'string', paragraph, 'book_id', book_id

        ssearch.add paragraph, paragraph_id
      end
      
      book.metainfo.each { |k, v| Tesniere::Books.hset book_id, k, v }
      Tesniere::Books.hset book_id, 'store_port',   store_port
      Tesniere::Books.hset book_id, 'ssearch_port', ssearch_port

      puts "#{file} is indexed."
    end

    puts "The books from #{directory} are indexed."
    puts "Store port is #{store_port}."
    puts "Ssearch port is #{ssearch_port}."
    puts "What would you like to do next?"
  else
    puts "The command '#{$_}' does not supported by protocol."
  end
end
