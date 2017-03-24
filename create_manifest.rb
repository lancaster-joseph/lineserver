require './source/manifest_generator.rb'

def run config_path, data_path
    manifest_generator = ManifestGenerator.new config_path, data_path

    manifest_generator.generate
end

def main argv
    run argv[0], argv[1]
end

main ARGV
