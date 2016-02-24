class PagesController < ApplicationController
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

    @participants = Participant.published
    @head_title = "Випускники"
  end
end