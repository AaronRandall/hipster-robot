class ArtistHipsterAnalyser
  require 'net/http'
  require 'json'

  ECHONEST_API_KEY = ""
  ECHONEST_HOT_URL = "http://developer.echonest.com/api/v4/artist/top_hottt?api_key=[API_KEY]&format=json&results=100&start=0&bucket=hotttnesss"
  
  def initialize
    @popular_artists = get_popular_artists
  end

  def artist_is_not_hipster(artist_name)
    if @popular_artists.include?(artist_name)
      return true
    end

    return false
  end

  private

  def get_popular_artists
    popular_artists = []

    uri = URI(ECHONEST_HOT_URL.gsub("[API_KEY]", ECHONEST_API_KEY))
    response = Net::HTTP.get_response(uri)

    if response.body
      json_response = JSON.parse(response.body)
      artists = json_response["response"]["artists"]

      artists.each do |artist|
        popular_artists.push(artist["name"]) 
      end
    end

    return popular_artists
  end

end
