RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  ([
   Article, Comment, Event, FormConfig, HomeAboutUsSlide, HomeContactInfo, HomeForm, HomePage, MainSliderSlide, User, Participant, TeamMember, Setting, Partner, AboutPageSliderSlide,
   EventTag, EventGalleryAlbum, EventGalleryImage
   #ActsAsTaggableOn::Tag, ActsAsTaggableOn::Tagging


  ]#+(Dir.glob(Rails.root.join('app/models/pages/*.rb')).each {|file| require file;}; classes = [] ;Pages.constants.each {|c| classes.push("Pages::#{c.to_s}") }; classes )

  ).each do | model |
    #config.model model.name do
    #visible false
    config.included_models += [model]
    if model.respond_to?(:translates?) && model.translates? && model.respond_to?(:translation_class)
      config.included_models += [model.translation_class]
    end
    #end
  end
end
