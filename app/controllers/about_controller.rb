class AboutController < ApplicationController


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
    @page_metadata = @page.try(&:page_metadata)
  end
end
