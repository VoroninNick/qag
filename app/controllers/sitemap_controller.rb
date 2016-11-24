class SitemapController < ApplicationController
  skip_all_before_action_callbacks

  def index
    #@content = Pages.sitemap_xml.try(:content) rescue nil
    #if @content.blank?
    @entries = Cms::SitemapElement.entries_for_resources(nil, :uk)
    #end

    render "cms/sitemap/index"
  end
end