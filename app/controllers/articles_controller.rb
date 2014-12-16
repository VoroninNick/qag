class ArticlesController < ApplicationController
  def list
    max_items_count = 10

    @breadcrumbs = {
        home: {},
        articles_list: {
            title: I18n.t('layout.breadcrumbs.articles_list'),
            link: {
                url: articles_list_path(locale: I18n.locale)
            }
        }
    }

    params_page = params[:page]
    if !params_page
      params_page = 1
    end

    @articles = Article.all.where(published: true)

    @articles = @articles.order('id desc')

    @paginated_articles =  @articles.paginate(page: params_page, per_page: max_items_count)

    if ajax?
      articles_html = render_to_string template: 'articles/_list_item', layout: false, locals: { events: @paginated_articles }
      #html_source = render_to_string template: 'devise/event_subscriptions/unsubscribe_form.html'
      data = { html: articles_html }
      render inline: "#{data.to_json}"
    end
  end

  def item
    find_item

    @breadcrumbs = {
        home: {},
        articles_list: {
            title: I18n.t('layout.breadcrumbs.events_list'),
            link: {
                url: articles_list_path(locale: I18n.locale)
            }
        },
        article_item: {
            title: @event.name,
            link: {
                url: article_item_path(item: @event.slug, tags: @event.tags.join('-'), locale: I18n.locale)
            }
        }
    }


  end

  private

  def find_item
    params_item = params[:item]
    #@article_ids_rows = Event.find_by_sql("select t.event_id as id from #{Event.translation_class.table_name} t where t.locale='#{I18n.locale}' and t.slug='#{params_item}'")
    #@article_ids = []
    #@article_ids_rows.each {|e| @event_ids.push e['id']  }
    #@articles = Event.find(@event_ids)
    #@article = (@events.respond_to?(:count) && @events.count > 0)? @events.first : nil

    @article.translations_by_locale.keys.each do |locale|
      I18n.with_locale(locale.to_sym) do
        @page_locale_links[locale.to_sym] = url_for(item: @article.slug, locale: locale)
      end

    end
  end
end
