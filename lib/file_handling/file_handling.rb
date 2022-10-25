module FileHandling
  def self.make_files(dir, save_file, name)
    files = Dir.glob("#{dir}/**/**_#{name}.json")
    dir = self.make_dir(save_file, name)
    
    files.each do |file|
      file = File.read(file)
      json = JSON.parse(file)

      json.each do |key, value|
        json_tmp = {}
        json_tmp[key] = value
        File.write("#{dir}/#{key}.json", JSON.dump(json_tmp))
      end
    end
  end

  def self.make_dir(save_file, name)
    dir = "#{save_file}/#{name}"
    FileUtils.mkdir_p(dir) unless File.exists?(dir)
    dir
  end

  def self.json_to_hash(dir)
    p dir
    dir = Dir["**/#{dir}"][0]
    hash = {}
    name = File.basename(dir, ".json")
    file = File.read(dir)
    
    JSON.parse(file)
  end
end