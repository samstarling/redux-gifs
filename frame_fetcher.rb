require 'rubygems'
require 'bbc_redux'
require 'nokogiri'

class FramestoreClient
  def self.get client, user, result, timestamp
    key = client.key(result.reference, user.session)
    url = "http://framestore.bbcsnippets.co.uk/generate/frame/by_disk_reference/#{result.reference}/#{timestamp}/480.jpg?key=#{key.value}"
    `wget -O output/#{result.reference}.jpg #{url}`
  end
end

class SearchClient
  def self.search client, term, page = 1
    offset = (page - 1) * 25
    url = "http://devapi.bbcredux.com/api/content/search?pname=#{term}&sort=date&repeats=false&channel=bbcone&offset=#{offset}"
    response = client.get(url)
    SearchPage.new response.body
  end
end

class SearchPage
  def initialize body
    @xml = Nokogiri::XML(body)
  end

  def results
    @xml.css('item').map { |item| SearchResult.new item }
  end

  def to_s
    results.map { |item| "#{item}\n" }
  end
end

class SearchResult
  def initialize node
    @node = node
  end

  def title
    @node.css('title').text
  end

  def reference
    @node.css('reference').text
  end

  def to_s
    "#{title} (#{reference})"
  end
end

client = BBC::Redux::Client.new
user = client.login(ENV['REDUX_USERNAME'], ENV['REDUX_PASSWORD'])
search = SearchClient.search client, "BBC+News+at+Ten"
search.results.each do |result|
  FramestoreClient.get client, user, result, 10
end

client.logout(user)
