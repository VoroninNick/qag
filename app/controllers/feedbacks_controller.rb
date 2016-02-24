class FeedbacksController < ApplicationController
  def index
    @breadcrumbs = {
        home: {},
        feedbacks: {
            title: I18n.t('layout.breadcrumbs.feedbacks'),
            link: {
                url: feedbacks_path
            }
        }
    }

    @head_title = "Відгуки"

    max_items_count = 10

    params_page = params[:page]
    if !params_page
      params_page = 1
    end

    @paginated_feedbacks = UserFeedback.published.paginate(page: params_page, per_page: max_items_count)
  end
end