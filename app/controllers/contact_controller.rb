class ContactController < ApplicationController
  def index
    @home_page = HomePage.first

    @home_contact_info = @home_page.home_contact_infos.first

    @map_markers = []

    m = {lat: @home_contact_info.map_latitude, lng: @home_contact_info.map_longtitude, address: @home_contact_info.address}
    @map_markers.push m


    # ------------------------------------------
    # contact page breadcrumbs
    # ------------------------------------------

    @breadcrumbs = {
        home: {},
        contact: {
            title: I18n.t('layout.breadcrumbs.contact'),
            link: {
                url: contact_path
            }
        }
    }

  end
end
