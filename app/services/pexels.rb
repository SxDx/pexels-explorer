class Pexels
  BASE_URL = "https://api.pexels.com/v1"

  attr_accessor :client

  def initialize
    @client = Faraday.new(
      url: BASE_URL,
      headers: { "Authorization": ENV["API_KEY"] },
    )
  end

  def search(query, filter_tags, boost_tags, page = 1)
    response = client.get("search") do |req|
      req.params[:query] = query
      req.params[:tags] = 1
      req.params[:page] = page
      req.params[:per_page] = 30
      req.params[:orientation] = :landscape
    end

    photos = JSON.parse(response.body, object_class: OpenStruct).photos

    if filter_tags.any?
      photos = photos.select do |photo|
        tags = photo.tags.map { |tag| tag.split(" ") }.flatten
        (tags & filter_tags).empty?
      end
    end

    if boost_tags.any?
      photos = photos.select do |photo|
        tags = photo.tags.map { |tag| tag.split(" ") }.flatten
        (tags & boost_tags).any?
      end
    end

    photos
  end
end
