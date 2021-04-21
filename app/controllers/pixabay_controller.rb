class PixabayController < ApplicationController
  def search
    @query = params.fetch(:query, "beach")
    @filter_tags = params.fetch(:filter_tags, %w[male female girl boy person hand couple hair people arms adult child man woman feet group].join(",")).split(",")

    @pixabay = Pixabay.new
    @photos, @total_results = @pixabay.search(@query, @filter_tags)
  end
end
