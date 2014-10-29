class Message < ActiveRecord::Base
	attr_accessible :name, :phone, :email, :text
end
