class SentenceSegmentationResource < Sinatra::Base
  post '/segment' do
    paragraph = Oj.load(request.body.read)['paragraph']
    sentences = Scalpel.cut(paragraph).map do |string|
      { 'string' => string }
    end

    Oj.dump sentences
  end
end
