Pathname.glob("./resources/*/" "*.rb").each { |file| require file }

class App < Sinatra::Base
  use PartialsResource
  use SentenceResource

  get '/' do
    slim :root
  end
end
