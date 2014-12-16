class UniqueSlugValidator < ActiveModel::Validator
  def validate(record)
    record_class = record.class
    another_records = record_class.where.not(id: record.id).includes(:translations)
    #if options[:fields].any?{|field| record.send(field) == "Evil" }
    #  record.errors[:base] << "This person is evil"
    #end

    locale_errors = {}

    records_with_same_slug = another_records.select {|r|
      I18n.available_locales.each {|locale| I18n.with_locale(locale) {
        if !locale_errors.keys.include?(locale.to_sym) then
          locale_errors[locale.to_sym] = "#{locale} шлях повинен бути унікальним(id: #{r.id})"  if r.translations_by_locale.keys.include?(locale.to_sym) && r.translations_by_locale[locale.to_sym].slug == record.translations_by_locale[locale.to_sym].slug
        end
      }
      }
    }
    # if records_with_same_slug.count > 0
    #
    # end
    locale_errors.each do |locale, message|
      record.errors[:base] << message
    end
  end
end