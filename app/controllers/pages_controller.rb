class PagesController < ApplicationController
  caches_page :students
  def students
    @breadcrumbs = {
        home: {},
        students: {
            title: I18n.t('layout.breadcrumbs.students'),
            link: {
                url: students_path
            }
        }
    }

    set_page_metadata(:students)

    @participants = Participant.published
  end
end