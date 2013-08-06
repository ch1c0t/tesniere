class SentenceSegmentationResource < Sinatra::Base
  post '/segment' do
    paragraph = Oj.load(request.body.read)['paragraph']
    Oj.dump Scalpel.cut(paragraph)
  end
end
