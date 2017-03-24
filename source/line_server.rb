require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'

class LineServer < Sinatra::Base

    MANIFEST_PATH = './data/manifest.txt'

    register Sinatra::ConfigFile

    config_file '../config.yml' 

    get '/lines/:idx' do |idx|
        manifest_path = MANIFEST_PATH
        data_path = settings.data_path

        # Index into the manifest/index, assuming 10 bytes per line 
        # including the newline character. 
        manifest_byte_offset = 10 * (idx.to_i - 1)

        data_byte_offset_base36 = nil
        File.open(manifest_path) do |manifest_handle|
            manifest_handle.seek(manifest_byte_offset, IO::SEEK_SET)
            data_byte_offset_base36 = manifest_handle.gets
        end

        # Return a 413 code if there is no such line in the index,
        # otherwise return the line.
        data_byte_offset = nil
        if data_byte_offset_base36.nil?
            halt 413
        else
            # Convert the base 36 back to base 10 to get the byte
            # offset into the data file.
            data_byte_offset = Integer(data_byte_offset_base36,36)
        end

        # Index into the data file to grab the line.
        line = nil
        File.open(data_path) do |data_handle|
            data_handle.seek(data_byte_offset, IO::SEEK_SET)
            line = data_handle.gets
        end

        # Return the line with 200 code.
        line
    end

end
