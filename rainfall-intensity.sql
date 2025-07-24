-- Tipping-bucket gauges → 5-min mm/h at the manhole gateway
CREATE SOURCE rain_raw (
    ts TIMESTAMP,
    station_id INT,
    tips INT)               -- 0.2 mm per tip
WITH (type='mqtt', broker='lorawan.city.io', topic='rain/+/tips', rate=1);

SELECT station_id,
       TUMBLE_START(ts, INTERVAL 5 MINUTES) AS window_start,
       SUM(tips) * 0.2 * 12                AS mm_per_hour
FROM rain_raw
GROUP BY station_id, TUMBLE(ts, INTERVAL 5 MINUTES)
EMIT EVERY 1 MINUTE;
