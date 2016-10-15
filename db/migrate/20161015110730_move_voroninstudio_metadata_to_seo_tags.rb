class MoveVoroninstudioMetadataToSeoTags < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        drop_table :seo_tags
        drop_table :seo_tag_translations if table_exists?(:seo_tag_translations)
      end

      dir.down do
        Cms.create_tables(only: [:seo_tags])
      end
    end

    rename_table :voronin_studio_page_metadata, :seo_tags
    rename_columns :seo_tags, head_title: :title, meta_description: :description, meta_keywords: :keywords

    rename_table :voronin_studio_page_metadatum_translations, :seo_tag_translations
    rename_columns :seo_tag_translations, head_title: :title, meta_description: :description, meta_keywords: :keywords, voronin_studio_page_metadatum_id: :seo_tag_id
  end
end

