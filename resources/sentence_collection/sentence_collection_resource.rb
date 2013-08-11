class SentenceCollectionResource < Sinatra::Base
  R = Redis.new :port => 6382
  Meta = Redis.new :port => 6382, :db => 1
  Predicators = Redis.new :port => 6382, :db => 3

  post '/sentence_collection/new' do
    sentences = Oj.load request.body.read

    sentences.each do |sentence|
      id = Meta.incr 'sentence-ids_counter'

      if sentence['predicators']
        string = sentence['predicators']
        string.split(';').each do |predicator|
          Predicators.sadd predicator, id
        end
      end

      sentence.each do |key, value|
        R.hset id, key, value
      end
    end
  end
end
