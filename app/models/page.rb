class Page < Cms::Page
  image :banner, :styles => { :banner => '2100x500#'},
        :url  => "/uploads/pages/:id/banner/:style/:basename.:extension",
        :path => ":rails_root/public:url",
        convert_options: {
            banner: "-quality 94 -interlace Plane",
        }
end