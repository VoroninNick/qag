Cms.config do
  use_translations do
    true
  end
end

Cms::CompressionConfig.initialize_compression

def has_aliases
  has_many :page_aliases, as: :page
  attr_accessible :page_aliases, :page_alias_ids
end
