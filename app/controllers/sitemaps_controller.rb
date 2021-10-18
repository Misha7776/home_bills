class SitemapsController < ApplicationController
  SHOW_CACHE_EXPIRATION = 1.hour
  layout :false
  before_filter :init_sitemap

  def index
    @properties = Property.all
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
    shopikon_expires_in SHOW_CACHE_EXPIRATION, public: true
    @sitemap = Sitemap.new
  end
end
