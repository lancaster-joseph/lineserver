require 'json'

class ManifestGenerator

    # Load config.
    def initialize config_path, data_path
        @data_path = data_path

        config_data = {}
        File.open(config_path, 'r') do |config_handle|
            config_data = JSON.parse config_handle.read       
        end

        manifest_path = config_data['manifest_path']

        manifest_dirname = File.dirname manifest_path
        Dir.mkdir manifest_dirname if not Dir.exist? manifest_dirname

        # Load manifest path
        @manifest_path = manifest_path
    end
    
    def generate 
        data_path = @data_path
        manifest_path = @manifest_path

        cumulative = 0

        # Create manifest/index for data file.
        File.open(manifest_path, 'w') do |manifest_handle|
            File.open(data_path, 'r') do |data_handle|
                data_handle.each do |line|

                    # Convert byte offset to base 36 to save on space because fewer bytes 
                    # are required to represent the byte offset into the data file.
                    base36 = cumulative.to_s(36)

                    # Pad the byte offset so that every line is the same length/size 
                    # and we can easily index any line the file no matter the size.
                    # We assume 10 bytes per line is enough which is 9 characters and a newline character.
                    # That is enough for over 100 trillion lines, which should be more than enough for the exercise.
                    padded_base36 = '0' * (9 - base36.length) + base36

                    manifest_handle.puts padded_base36

                    # Get the number of bytes in the next line and add it to the cumulative/offset.
                    cumulative += line.length
                end
            end
        end 
    end

end
