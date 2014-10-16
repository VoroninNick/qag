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
  end
end
