-- =============================================================================
-- 1) Totals by participant type (counts + % of all accidents)
--    Simple, high-signal metric showing how often each road user type is involved.
-- =============================================================================
WITH totals AS (
  SELECT COUNT(*)::numeric AS n
  FROM fact_accident
  WHERE year = 2024
),
counts AS (
  SELECT
    SUM(is_car)::numeric           AS car,
    SUM(is_bicycle)::numeric       AS bicycle,
    SUM(is_pedestrian)::numeric    AS pedestrian,
    SUM(is_motorcycle)::numeric    AS motorcycle,
    SUM(is_goods_vehicle)::numeric AS goods_vehicle,
    SUM(is_other_vehicle)::numeric AS other_vehicle
  FROM fact_accident
  WHERE year = 2024
),
unnested AS (
  SELECT * FROM counts
)
SELECT 
  k AS participant_type,
  v::int AS accidents_involving,
  ROUND(100.0 * v / t.n, 2) AS pct_of_all_accidents
FROM totals t,
LATERAL (VALUES
  ('Car',             (SELECT car           FROM unnested)),
  ('Bicycle',         (SELECT bicycle       FROM unnested)),
  ('Pedestrian',      (SELECT pedestrian    FROM unnested)),
  ('Motorcycle',      (SELECT motorcycle    FROM unnested)),
  ('Goods vehicle',   (SELECT goods_vehicle FROM unnested)),
  ('Other vehicle',   (SELECT other_vehicle FROM unnested))
) AS kv(k, v)
ORDER BY accidents_involving DESC;

-- =============================================================================
-- 2) Bicycle-involved hotspots (Top 10 districts by absolute count)
-- =============================================================================
SELECT
  d.region_name_en,
  d.district_name_en,
  COUNT(*) AS bicycle_involved
FROM fact_accident f
JOIN dim_district d
  ON d.region_code = f.region_code
 AND d.district_code = f.district_code
WHERE f.year = 2024
  AND f.is_bicycle = 1
GROUP BY d.region_name_en, d.district_name_en
ORDER BY bicycle_involved DESC
LIMIT 10;

-- =============================================================================
-- 3) Weekend vs Weekday bicycle involvement (clear KPI)
--    Quick view of how cycling accidents shift on weekends.
-- =============================================================================
WITH by_group AS (
  SELECT
    CASE WHEN weekday IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_group,
    COUNT(*) AS total,
    SUM(is_bicycle) AS bike
  FROM fact_accident
  WHERE year = 2024
  GROUP BY 1
)
SELECT
  day_group,
  total,
  bike AS bicycle_involved,
  ROUND(100.0 * bike / NULLIF(total,0), 2) AS pct_bicycle
FROM by_group
ORDER BY day_group;