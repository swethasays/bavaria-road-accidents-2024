-- Time-based patterns for Bavaria Accident Atlas 2024

-- =============================================================================
-- 1) Accidents by weekday with names
-- =============================================================================
SELECT
  weekday,
  weekday_label,
  COUNT(*) AS accidents
FROM fact_accident
WHERE year = 2024
GROUP BY weekday, weekday_label
ORDER BY weekday;

-- =============================================================================
-- 2) Accidents by hour of day (0..23)
-- =============================================================================
SELECT
  hour,
  COUNT(*) AS accidents
FROM fact_accident
WHERE year = 2024
GROUP BY hour
ORDER BY hour;

-- =============================================================================
-- 3) Weekday × Hour "heatmap" matrix
--    Each row = weekday, each column = hour, value = accident count.
--    (Pivot-like view; great for spotting rush-hour patterns)
-- =============================================================================
SELECT
  weekday,
  MIN(weekday_label) AS weekday_label,
  SUM(CASE WHEN hour =  0 THEN 1 ELSE 0 END) AS h00,
  SUM(CASE WHEN hour =  1 THEN 1 ELSE 0 END) AS h01,
  SUM(CASE WHEN hour =  2 THEN 1 ELSE 0 END) AS h02,
  SUM(CASE WHEN hour =  3 THEN 1 ELSE 0 END) AS h03,
  SUM(CASE WHEN hour =  4 THEN 1 ELSE 0 END) AS h04,
  SUM(CASE WHEN hour =  5 THEN 1 ELSE 0 END) AS h05,
  SUM(CASE WHEN hour =  6 THEN 1 ELSE 0 END) AS h06,
  SUM(CASE WHEN hour =  7 THEN 1 ELSE 0 END) AS h07,
  SUM(CASE WHEN hour =  8 THEN 1 ELSE 0 END) AS h08,
  SUM(CASE WHEN hour =  9 THEN 1 ELSE 0 END) AS h09,
  SUM(CASE WHEN hour = 10 THEN 1 ELSE 0 END) AS h10,
  SUM(CASE WHEN hour = 11 THEN 1 ELSE 0 END) AS h11,
  SUM(CASE WHEN hour = 12 THEN 1 ELSE 0 END) AS h12,
  SUM(CASE WHEN hour = 13 THEN 1 ELSE 0 END) AS h13,
  SUM(CASE WHEN hour = 14 THEN 1 ELSE 0 END) AS h14,
  SUM(CASE WHEN hour = 15 THEN 1 ELSE 0 END) AS h15,
  SUM(CASE WHEN hour = 16 THEN 1 ELSE 0 END) AS h16,
  SUM(CASE WHEN hour = 17 THEN 1 ELSE 0 END) AS h17,
  SUM(CASE WHEN hour = 18 THEN 1 ELSE 0 END) AS h18,
  SUM(CASE WHEN hour = 19 THEN 1 ELSE 0 END) AS h19,
  SUM(CASE WHEN hour = 20 THEN 1 ELSE 0 END) AS h20,
  SUM(CASE WHEN hour = 21 THEN 1 ELSE 0 END) AS h21,
  SUM(CASE WHEN hour = 22 THEN 1 ELSE 0 END) AS h22,
  SUM(CASE WHEN hour = 23 THEN 1 ELSE 0 END) AS h23
FROM fact_accident
WHERE year = 2024
GROUP BY weekday, weekday_label
ORDER BY weekday;

-- =============================================================================
-- 4) Peak hour per weekday (which hour is worst on each weekday?)
-- =============================================================================
WITH counts AS (
  SELECT weekday, hour, COUNT(*) AS n
  FROM fact_accident
  WHERE year = 2024
  GROUP BY weekday, hour
)
SELECT DISTINCT ON (weekday)
  weekday,
  hour AS peak_hour,
  n   AS accidents_in_peak_hour
FROM counts
ORDER BY weekday, n DESC, hour;

-- =============================================================================
-- 5) Weekday vs Weekend totals
-- =============================================================================
SELECT
  CASE 
    WHEN weekday IN (1,7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_group,
  COUNT(*) AS accidents
FROM fact_accident
WHERE year = 2024
GROUP BY day_group
ORDER BY day_group;

-- =============================================================================
-- 6) Peak hour per weekday (which hour has the most accidents on each weekday?)
-- =============================================================================
WITH counts AS (
  SELECT weekday, weekday_label, hour, COUNT(*) AS n
  FROM fact_accident
  WHERE year = 2024
  GROUP BY weekday, weekday_label, hour
)
SELECT DISTINCT ON (weekday)
  weekday,
  weekday_label,
  hour AS peak_hour,
  n   AS accidents_in_peak_hour
FROM counts
ORDER BY weekday, n DESC, hour;

-- =============================================================================
-- 7) Rush-hour vs Off-peak 
--    Here: Morning 7–9, Evening 16–19, Rest = Off-peak
-- =============================================================================
SELECT
  CASE
    WHEN hour BETWEEN 7 AND 9  THEN 'Morning rush (7–9)'
    WHEN hour BETWEEN 16 AND 19 THEN 'Evening rush (16–19)'
    ELSE 'Off-peak'
  END AS time_bucket,
  COUNT(*) AS accidents
FROM fact_accident
WHERE year = 2024
GROUP BY 1
ORDER BY accidents DESC;