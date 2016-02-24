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
    if current_user
      @feedback = UserFeedback.new
    end
  end

  def create
    if !current_user
      return render nothing: true, status: 401
    end
    feedback_params = params[:feedback]
    @feedback = UserFeedback.new(feedback_params)
    @feedback.user = current_user
    if @feedback.save
      render "_list_item", locals: {articles: [@feedback]}, status: 201, layout: false
    end

  end
end