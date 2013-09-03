require 'json'

EXCLUDED_FILES = %w[Gemfile.lock log public bin tmp development.sqlite3 test.sqlite3]

def files_for_path(path)
  Dir.entries(path)
   .select { |file| file[0] != '.' and !EXCLUDED_FILES.include?(file) }
   .map do |file|
    filepath = File.join(path, file)
    id = filepath.sub(ROOT, '')
    hash = {id: id, name: file, isDirectory: File.directory?(filepath)}

    if hash[:isDirectory]
      hash[:children] = files_for_path(filepath)
    else
      File.open filepath do |file|
        content = file.read

        if content.valid_encoding?
          if content.include?('#!ignore')
            hash = nil
          else
            expectations = []

            content.gsub! /#\!\{(\w*)\s(\w*)(.*?)#\!\}/m do |match|
              name = $1
              action = $2
              completed = $3

              if name != 'ignore'
                regex = completed.strip.gsub(/([\.\+\*\{\}\(\)])/){ '\\' + $1 }.gsub(/\s+/, '\s+').gsub(/["']/, '["\']')
                expectations << {stepName: name, regex: regex, action: action, completion: {index: content.index(match), value: completed}}
              end

              ''
            end

            hash[:content] = content
            hash[:expectations] = expectations if expectations.size > 0
          end
        end
      end
    end

    hash
   end
   .compact
end

ROOT = ENV["BATMAN_RDIO_PATH"]
throw "Please provide BATMAN_RDIO_PATH" unless ROOT

files = files_for_path(File.expand_path(ROOT))

f = File.new(File.join(File.dirname(__FILE__), 'app_files.json'), 'w+')
f.write(files.to_json)
f.close
