module VoroninStudio
  module PageHelper
    def acts_as_page
      self.belongs_to :page, polymorphic: true
    end

    
  end
end