class SentenceResource < Sinatra::Base
  R = Redis.new :port => 6381
  Meta = Redis.new :port => 6381, :db => 1

  post '/sentences' do
    hash = Oj.load request.body.read

    id = Meta.incr 'ids_counter'
    R.hset id,  'string',    hash['string']
    R.hset id,  'se_id',     hash['se_id']
    (R.hset id, 'mc_amount', hash['mc_amount']) unless hash['mc_amount'].nil?
  end
end
