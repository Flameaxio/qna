class Search
  attr_accessor :result, :type, :search

  def initialize(attributes = nil)
    raise ArgumentError unless Search.searchables.include?(attributes[:type])

    @type = attributes[:type]
    @search = attributes[:search]
  end

  def perform
    if type == 'All'
      @result = ThinkingSphinx.search(@search)
    else
      klass = Object.const_get type.delete_suffix('s').to_s
      @result = klass.send('search', @search)
    end
  end

  def self.searchables
    %w[All Questions Answers Comments Users]
  end
end
