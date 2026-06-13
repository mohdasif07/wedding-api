module Paginatable
  extend ActiveSupport::Concern
  include Pagy::Backend

  private

  def paginate(scope)
    pagy, records = pagy(scope, limit: per_page)
    set_pagination_headers(pagy)
    records
  end

  def per_page
    [params.fetch(:per_page, 20).to_i, 100].min
  end

  def set_pagination_headers(pagy)
    response.headers["X-Total-Count"] = pagy.count.to_s
    response.headers["X-Page"] = pagy.page.to_s
    response.headers["X-Per-Page"] = pagy.limit.to_s
  end
end
