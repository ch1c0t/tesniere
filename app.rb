Pathname.glob("./resources/*/" "*.rb").each { |file| require file }

class App < Sinatra::Base
  use PartialsResource
  use SentenceResource
  use SentenceSegmentationResource
  use SentenceCollectionResource
  use ParagraphCollectionResource

  get '/' do
    slim :root
  end

  get '/scalpel' do
    slim :scalpel
  end

  get '/settings' do
    slim :settings
  end

  get '/search' do
    slim :search
  end
end
