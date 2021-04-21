class Pixabay
  BASE_URL = "https://pixabay.com/api/"

  attr_accessor :client

  def initialize
    @client = Faraday.new(
      url: BASE_URL,
      params: { key: ENV["PIXABAY_API_KEY"] },
    )
  end

  def search(query, filter_tags, page = 1)
    response = client.get do |req|
      req.params[:q] = query
      req.params[:orientation] = "horizontal"
      req.params[:category] = "backgrounds"
      req.params[:safesearch] = true
      req.params[:page] = 1
      req.params[:per_page] = 100
    end

    data = JSON.parse(response.body, object_class: OpenStruct)
    photos = data.hits
    total_results = data.total

    photos = photos.map do |photo|
      photo.rating = 0
      photo
    end

    # if filter_tags.any? && photos&.any?
    #   photos = photos.select do |photo|
    #     tags = photo.tags.split(",").map { |tag| tag.split(" ") }.flatten
    #     photo.rating -= (tags & filter_tags).size
    #   end
    # end

    # photos = photos.sort_by { |photo| photo.rating * -1 }

    [photos, total_results]
  end
end
