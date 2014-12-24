require 'snow_flake'

snow_flake_server_id = 0
::WebSiteSnowFlakeGenerator = SnowFlake.new(snow_flake_server_id)
