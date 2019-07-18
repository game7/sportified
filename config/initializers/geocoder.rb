Geocoder.configure(
    ip_lookup: :geoip2,
    geoip2: {
      file: GeoLite2City::DB_PATH
    }
  )