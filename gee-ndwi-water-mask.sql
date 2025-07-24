-- Sentinel-2 NDWI tiles → flag tiles >30 % water
CREATE SOURCE gee_ndwi (
    ts TIMESTAMP,
    tile_id STRING,
    ndwi IMAGE(FLOAT32, 256, 256))
WITH (type='http',
      url='https://earthengine.googleapis.com/v1alpha/tiles/ndwi/latest',
      refresh=15);

SELECT tile_id,
       ts,
       PERCENT_TRUE(ndwi > 0.3) AS water_pct
FROM gee_ndwi
WHERE water_pct > 30
EMIT EVERY 15 MINUTES;
