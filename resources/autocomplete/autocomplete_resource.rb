class AutocompleteResource < Sinatra::Base
  post '/autocomplete' do
    query = Oj.load request.body.read
    trie = Ssearch.new(port: query['ssearch']).trie

    autocompletions = trie.prefix query['collocation']
    Oj.dump autocompletions
  end
end
