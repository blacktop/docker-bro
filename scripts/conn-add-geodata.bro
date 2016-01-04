##! Add countries for the originator and responder of a connection
##! to the connection logs.

module Conn;

export {
	redef record Conn::Info += {
		## Country code for the originator of the connection based
		## on a GeoIP lookup.
		orig_cc: string &optional &log;
		## Country code for the responser of the connection based
		## on a GeoIP lookup.
		resp_cc: string &optional &log;
		## City for the originator of the connection based
		## on a GeoIP lookup.
		orig_city: string &optional &log;
		## Cityfor the responser of the connection based
		## on a GeoIP lookup.
		resp_city: string &optional &log;
		## City for the originator of the connection based
		## on a GeoIP lookup.
		orig_region: string &optional &log;
		## Cityfor the responser of the connection based
		## on a GeoIP lookup.
		resp_region: string &optional &log;
		## latitude for the originator of the connection based
		## on a GeoIP lookup.
		orig_lat: double &optional &log;
		## longitude for the originator of the connection based
		## on a GeoIP lookup.
		orig_long: double &optional &log;
		## latitudefor the responser of the connection based
		## on a GeoIP lookup.
		resp_lat: double &optional &log;
		## longitude for the responser of the connection based
		## on a GeoIP lookup.
		resp_long: double &optional &log;
	};
}

event connection_state_remove(c: connection)
	{
	local orig_loc = lookup_location(c$id$orig_h);
	if ( orig_loc?$country_code )
		c$conn$orig_cc = orig_loc$country_code;
	if ( orig_loc?$region )
		c$conn$orig_region = orig_loc$region;    
	if ( orig_loc?$city )
		c$conn$orig_city = orig_loc$city;
	if ( orig_loc?$latitude )
		c$conn$orig_lat = orig_loc$latitude;
	if ( orig_loc?$longitude )
		c$conn$orig_long = orig_loc$longitude;

	local resp_loc = lookup_location(c$id$resp_h);
	if ( resp_loc?$country_code )
		c$conn$resp_cc = resp_loc$country_code;
	if ( resp_loc?$region )
		c$conn$resp_region = resp_loc$region;
	if ( resp_loc?$city )
		c$conn$resp_city = resp_loc$city;
	if ( resp_loc?$latitude )
		c$conn$resp_lat = resp_loc$latitude;
	if ( resp_loc?$longitude )
		c$conn$resp_long = resp_loc$longitude;
	}
