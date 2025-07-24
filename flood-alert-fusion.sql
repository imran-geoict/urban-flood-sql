SELECT ST_MAKEPOINT(bus.lon, bus.lat) AS flood_point,
       'warning'                       AS level
FROM rainfall_intensity AS rain,
     traffic_ponding     AS traffic,
     gee_water_tiles     AS gee
WHERE rain.mm_per_hour > 30
  AND traffic.loop_id = gee.tile_id
  AND gee.water_pct   > 30
ALIGN WINDOW 1 MINUTE
EMIT EVERY 30 SECONDS;
