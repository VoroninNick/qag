class Page < Cms::Page
  image :banner, :styles => { :banner => '2100x500#'},
        :url  => "/assets/pages/:id/banner/:style/:basename.:extension",
        :path => ":rails_root/public/assets/pages/:id/banner/:style/:basename.:extension",
        convert_options: {
            banner: "-quality 94 -interlace Plane",
        }
end