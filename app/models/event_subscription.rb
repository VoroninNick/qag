class EventSubscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :event, :event_id
  attr_accessible :user, :user_id

  attr_accessible :first_name, :last_name, :email, :contact_phone

  accepts_nested_attributes_for :event, :allow_destroy => true
  attr_accessible :event_attributes

  accepts_nested_attributes_for :user, :allow_destroy => true
  attr_accessible :user_attributes

  rails_admin do
    navigation_label "Events"
    weight 1

    edit do
      field :disabled
      field :user
      field :event
      field :first_name
      field :last_name
      field :email
      field :contact_phone

    end
  end
end