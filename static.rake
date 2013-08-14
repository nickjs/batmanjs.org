require 'json'

EXCLUDED_FILES = %w[Gemfile.lock log public config.ru db bin README tmp]

def files_for_path(path)
  Dir.entries(path)
   .select { |file| file[0] != '.' and !EXCLUDED_FILES.include?(file)}
   .map do |file|
    filepath = File.join(path, file)
    hash = {id: filepath, name: file, isDirectory: File.directory?(filepath)}

    if hash[:isDirectory]
      hash[:children] = files_for_path(hash[:id])
    else
      hash[:content] = File.open(filepath).read
    end

    hash
  end
end

root_path = ENV["BATMAN_RDIO_PATH"]
throw "Please provide BATMAN_RDIO_PATH" unless root_path

files = files_for_path(File.expand_path(root_path))

f = File.new(File.join(File.dirname(__FILE__), 'app_files.json'), 'w+')
f.write(files.to_json)
f.close
