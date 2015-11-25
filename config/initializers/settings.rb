class Settings
  def self.[](arg)
    config = YAML.load_file(File.open(Rails.root.join("config/settings/development.yml")))
    path_fragments = arg.split(".")
    res = config

    path_fragments.each do |f|
      res = res[f]
      if res.nil?
        return nil
      end
    end

    return res
  end
end