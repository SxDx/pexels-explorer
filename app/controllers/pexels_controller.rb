class PexelsController < ApplicationController
  def search
    @query = params.fetch(:query, "background")

    @filter_tags = params.fetch(:filter_tags, %w[male female person hand couple hair].join(",")).split(",")
    @boost_tags = params.fetch(:boost_tags, %w[background wallpaper].join(",")).split(",")

    @pexels = Pexels.new
    @photos, @total_results, @page  = @pexels.search_until(@query, @filter_tags, @boost_tags)
  end
end
