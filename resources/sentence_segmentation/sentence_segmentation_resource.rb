class SentenceSegmentationResource < Sinatra::Base
  Meta = Redis.new :port => 6382, :db => 2

  post '/segment' do
    params = Oj.load request.body.read
    params = params.delete_if { |_, value| value.empty? }
    params['paragraph_id'] = Meta.incr 'paragraph-ids_counter'

    paragraph = params.delete 'paragraph'
    sentences = Scalpel.cut(paragraph).map do |string|
      blank_for_generalization = { 'generalization' => string[0..-2] }

      { 'string' => string }
        .merge params
        .merge blank_for_generalization
    end

    Oj.dump sentences
  end
end
