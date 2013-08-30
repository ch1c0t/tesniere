require 'pathname'
require 'gutenberg/book'

require '../models/book_collection'

while gets
  case $_
  when /\d+:./
    port, directory = $_.split ':'
    book_collection = BookCollection.new :port => port

    Pathname.glob("#{directory.strip}/*.txt").each do |file|
      book = Gutenberg::Book.new file
      book_id = book_collection.meta.incr 'book_counter'

      book.metainfo.each { |k, v| book_collection.books.hset book_id, k, v }

      # Should I dry it or don't even bother?
      book.paragraphs.each do |paragraph|
        paragraph_id = book_collection.meta.incr 'paragraph_counter'
        book_collection.paragraphs.hmset paragraph_id, 'string', paragraph, 'book_id', book_id

        paragraph.sentences.each do |sentence|
          sentence_id = book_collection.meta.incr 'sentence_counter'
          book_collection.sentences.hmset sentence_id, 'string', sentence, 'paragraph_id', paragraph_id
        end
      end

      puts "#{file} is saved."
    end

    puts "The books from #{directory} are saved."
    puts "BookCollection port is #{port}."
    puts "What would you like to do next?"
  else
    puts "The command '#{$_}' does not supported by protocol."
  end
end
