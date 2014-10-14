class AddStatusToUserTranslation < ActiveRecord::Migration
  def change
    add_column User.translation_class.table_name, :status, :string
  end
end
