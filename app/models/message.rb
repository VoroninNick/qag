class Message < ActiveRecord::Base
	attr_accessible *attribute_names

	validates_presence_of :name, :phone, :email, :text

	rails_admin do
		navigation_label I18n.t('rails_admin.navigation_labels.other')
		label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
		label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

		field :name do
			if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
				label asd
			end
		end
		field :phone do
			if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
				label asd
			end
		end
		field :email do
			if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
				label asd
			end
		end
		field :text do
			if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
				label asd
			end
		end
	end
end
