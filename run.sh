ruby create_manifest.rb config.json $1 # Pre-process: Create manifest/index.  The data file path must be relative to the location of this script.

sed -i.bak "s!data_path: .*!data_path: ${1}!g" config.yml # Pass data filepath to server through config.
ruby run_line_server.rb # Run the line server.
