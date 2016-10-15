class AboutController < ApplicationController
  caches_page :index

  def index
    @breadcrumbs = {
        home: {},
        about_us: {
            title: I18n.t('layout.breadcrumbs.about_us'),
            link: {
                url: about_path
            }
        }
    }

    @participants = Participant.published.sort_by_sorting_position
    @team_members = TeamMember.published.sort_by_sorting_position

    @about_slides = AboutPageSliderSlide.published.sort_by_sorting_position

    @about_page = AboutPage.first

    @page = @about_page
    set_page_metadata(@page)
  end
end
