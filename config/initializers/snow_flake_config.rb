require 'snow_flake'

snow_flake_server_id = 1
::WebSiteSnowFlakeGenerator = SnowFlake.new(snow_flake_server_id)
