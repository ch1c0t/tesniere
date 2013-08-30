class BookCollection
  attr_reader :meta, :books, :paragraphs, :sentences

  def initialize params = {}
    port = params[:port]

    @meta       = Redis.new :port => port
    @books      = Redis.new :port => port, :db => 1
    @paragraphs = Redis.new :port => port, :db => 2
    @sentences  = Redis.new :port => port, :db => 3
  end
end
