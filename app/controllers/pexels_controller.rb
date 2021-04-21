class PexelsController < ApplicationController
  def search
    @query = params.fetch(:query, "background")

    @filter_tags = params.fetch(:filter_tags, %w[male female girl boy person hand couple hair people arms adult child man woman feet group].join(",")).split(",")
    @boost_tags = params.fetch(:boost_tags, %w[background wallpaper].join(",")).split(",")

    @pexels = Pexels.new
    @photos, @total_results, @page  = @pexels.search(@query, @filter_tags, @boost_tags)
  end
end
