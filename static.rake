require 'json'

EXCLUDED_FILES = %w[Gemfile.lock log public config.ru db bin README.rdoc Rakefile tmp]

def files_for_path(path)
  Dir.entries(path)
   .select { |file| file[0] != '.' and !EXCLUDED_FILES.include?(file)}
   .map do |file|
    filepath = File.join(path, file)
    id = filepath.sub(ROOT, '')
    hash = {id: id, name: file, isDirectory: File.directory?(filepath)}

    if hash[:isDirectory]
      hash[:children] = files_for_path(filepath)
    else
      hash[:content] = File.open(filepath).read
    end

    hash
  end
end

ROOT = ENV["BATMAN_RDIO_PATH"]
throw "Please provide BATMAN_RDIO_PATH" unless ROOT

files = files_for_path(File.expand_path(ROOT))

f = File.new(File.join(File.dirname(__FILE__), 'app_files.json'), 'w+')
f.write(files.to_json)
f.close
