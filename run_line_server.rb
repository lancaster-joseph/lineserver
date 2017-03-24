require './source/line_server.rb'

def run config_path, data_path
    LineServer.run!
end

def main argv
    run argv[0], argv[1] 
end

main ARGV
