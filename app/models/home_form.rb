class HomeForm < ActiveRecord::Base
  attr_accessible :name, :phone, :email, :message, :locale

  rails_admin do
    navigation_label 'other'
  end
end
