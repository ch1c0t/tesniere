class ParagraphCollectionResource < Sinatra::Base
  post '/paragraph_collection' do
    query = Oj.load request.body.read

    store   = Redis.new :port => query['store']
    ssearch = Ssearch.new :redis_port => query['ssearch']

    ids = ssearch.find query['collocation']
    sentences = ids.take(20).map { |id| store.hget id, 'string' }

    Oj.dump sentences
  end
end
