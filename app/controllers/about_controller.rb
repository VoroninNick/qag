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

    @participants = Participant.all.where("published = 't' ")
    @team_members = TeamMember.all.where("published = 't' ")

    @about_slides = AboutPageSliderSlide.where("published = 't' ").order('order_index asc')

    @about_page = AboutPage.first
  end
end
