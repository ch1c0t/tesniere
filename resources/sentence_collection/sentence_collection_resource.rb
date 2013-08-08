class SentenceCollectionResource < Sinatra::Base
  R = Redis.new :port => 6382
  Meta = Redis.new :port => 6382, :db => 1

  post '/sentence_collection/new' do
    sentences = Oj.load request.body.read

    sentences.each do |sentence|
      id = Meta.incr 'sentence-ids_counter'
      R.hset id, 'string', sentence['string']
    end
  end
end
