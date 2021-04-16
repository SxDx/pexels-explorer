class Pexels
  BASE_URL = "https://api.pexels.com/v1"

  attr_accessor :client

  def initialize
    @client = Faraday.new(
      url: BASE_URL,
      headers: { "Authorization": ENV["API_KEY"] },
    )
  end

  def search_until(query, filter_tags, boost_tags, limit = 80)
    all_photos = []
    remaining_results = 10_000
    total_results = 10_000
    page = 1

    while all_photos.size < 80 && remaining_results > 0
      result_photos, total_results = Pexels.new.search(query, filter_tags, boost_tags, page)

      if result_photos&.any?
        all_photos = all_photos + result_photos
        remaining_results = total_results - result_photos.size
      end

      remaining_results = 0 if result_photos.empty?

      page += 1
    end

    [all_photos, total_results, page - 1]
  end


  def search(query, filter_tags, boost_tags, page = 1)
    response = client.get("search") do |req|
      req.params[:query] = query
      req.params[:tags] = 1
      req.params[:page] = page
      req.params[:per_page] = 80
      req.params[:orientation] = :landscape
    end

    data = JSON.parse(response.body, object_class: OpenStruct)
    photos = data.photos
    total_results = data.total_results

    if filter_tags.any? && photos&.any?
      photos = photos.select do |photo|
        tags = photo.tags.map { |tag| tag.split(" ") }.flatten
        (tags & filter_tags).empty?
      end
    end

    if boost_tags.any? && photos&.any?
      photos = photos.select do |photo|
        tags = photo.tags.map { |tag| tag.split(" ") }.flatten
        (tags & boost_tags).any?
      end
    end

    [photos, total_results]
  end
end
