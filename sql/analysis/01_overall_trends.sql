-- 01_overall_trends.sql
-- High-level metrics and trends for Bavaria Accident Atlas 2024
-- Tables: fact_accident (facts), dim_district (lookup)

-- =============================================================================
-- 1) Total accidents in 2024
-- =============================================================================
SELECT COUNT(*) AS total_accidents_2024
FROM fact_accident
WHERE year = 2024;

-- =============================================================================
-- 2) Accidents by month (chronological, with month name)
-- =============================================================================
SELECT
  year,
  month,
  TO_CHAR(MAKE_DATE(year, month, 1), 'Mon') AS month_short,
  COUNT(*) AS accidents
FROM fact_accident
WHERE year = 2024
GROUP BY year, month
ORDER BY year, month;

-- =============================================================================
-- 3) Accidents by region
-- =============================================================================
SELECT
  d.region_name_en,
  COUNT(*) AS accidents
FROM fact_accident f
JOIN dim_district d
  ON d.region_code = f.region_code
 AND d.district_code = f.district_code
WHERE f.year = 2024
GROUP BY d.region_name_en
ORDER BY accidents DESC;

-- =============================================================================
-- 4) Top 10 districts by accidents
-- =============================================================================
SELECT
  d.region_name_en,
  d.district_name_en,
  COUNT(*) AS accidents
FROM fact_accident f
JOIN dim_district d
  ON d.region_code = f.region_code
 AND d.district_code = f.district_code
WHERE f.year = 2024
GROUP BY d.region_name_en, d.district_name_en
ORDER BY accidents DESC
LIMIT 10;

-- =============================================================================
-- 5) Severity distribution (counts & percentages)
-- =============================================================================
WITH sev AS (
  SELECT severity_label, COUNT(*) AS cnt
  FROM fact_accident
  WHERE year = 2024
  GROUP BY severity_label
),
tot AS (
  SELECT SUM(cnt) AS total FROM sev
)
SELECT
  s.severity_label,
  s.cnt AS accidents,
  ROUND(100.0 * s.cnt / t.total, 2) AS total_percen
FROM sev s CROSS JOIN tot t
ORDER BY accidents DESC;

-- =============================================================================
-- 6) Month-over-Month (MoM) Accident Trends
-- =============================================================================
-- This query shows how accident counts change from one month to the next.
-- Example: if February has 400 fewer accidents than January, the result is -400.
-- Positive values mean an increase compared to the previous month,
-- negative values mean a decrease.
WITH m AS (
  SELECT
    MAKE_DATE(year, month, 1) AS month_start,
    COUNT(*) AS accidents
  FROM fact_accident
  WHERE year = 2024
  GROUP BY year, month
)
SELECT
  TO_CHAR(month_start, 'YYYY-MM') AS ym,
  accidents,
  accidents - LAG(accidents) OVER (ORDER BY month_start) AS mom_change
FROM m
ORDER BY ym;