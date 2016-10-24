class CreateCmsHtmlBlocksTable < ActiveRecord::Migration
  def up
    Cms::HtmlBlock.create_translation_table!(content: :text)
  end

  def down
    Cms::HtmlBlock.create_translation_table!(content: :text)
  end
end
