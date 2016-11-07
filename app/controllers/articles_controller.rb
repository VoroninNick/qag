class ArticlesController < ApplicationController
  caches_page :item, :list

  def list
    max_items_count = 10

    @breadcrumbs = {
        home: {},
        articles_list: {
            title: I18n.t('layout.breadcrumbs.articles_list'),
            link: {
                url: articles_list_path
            }
        }
    }

    @_page_banner_title = "Публікації"

    params_page = params[:page]
    if !params_page
      params_page = 1
    end

    @articles = Article.published

    @articles = @articles.order('id desc')

    @paginated_articles =  @articles.paginate(page: params_page, per_page: max_items_count)

    if ajax?
      articles_html = render_to_string template: 'articles/_list_item.html', layout: false, locals: { articles: @paginated_articles }
      data = { html: articles_html }
      render json: data
    end

    @page = Pages::ArticlesList.first
    set_page_metadata(@page)
  end

  def item
    find_item

    if !@article_not_found
      @breadcrumbs = {
          home: {},
          articles_list: {
              title: I18n.t('layout.breadcrumbs.articles_list'),
              link: {
                  url: articles_list_path
              }
          },
          article_item: {
              title: @article.name,
              link: {
                  url: article_item_path(item: @article.url_fragment)
              }
          }
      }

      @related_articles = @article.related_articles

      @page = @article
      set_page_metadata(@page)

      resource = @article
    else
      alias_or_not_found
    end




  end

  private

  def find_item
    params_item = params[:item]
    #@article_ids_rows = Event.find_by_sql("select t.event_id as id from #{Event.translation_class.table_name} t where t.locale='#{I18n.locale}' and t.url_fragment='#{params_item}'")
    #@article_ids = []
    #@article_ids_rows.each {|e| @event_ids.push e['id']  }
    #@articles = Event.find(@event_ids)
    #@article = (@events.respond_to?(:count) && @events.count > 0)? @events.first : nil
    @article = Article.published.where(url_fragment: params_item).first
    @article_not_found = @article.nil?
    unless @article_not_found
      @article.translations_by_locale.keys.each do |locale|
        I18n.with_locale(locale.to_sym) do
          @page_locale_links[locale.to_sym] = url_for(item: @article.url_fragment)
        end
      end
    end
  end
end
