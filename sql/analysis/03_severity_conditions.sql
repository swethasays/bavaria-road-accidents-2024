-- 03_severity_conditions.sql
-- Severity × conditions analyses for Bavaria Accident Atlas 2024

-- =============================================================================
-- 1) Severity distribution (counts & % of total)
-- =============================================================================
WITH sev AS (
  SELECT severity_label, COUNT(*) AS cnt
  FROM fact_accident
  WHERE year = 2024
  GROUP BY severity_label
),
tot AS ( SELECT SUM(cnt) AS total FROM sev )
SELECT
  s.severity_label,
  s.cnt AS accidents,
  ROUND(100.0 * s.cnt / t.total, 2) AS pct_of_total
FROM sev s CROSS JOIN tot t
ORDER BY accidents DESC;

-- =============================================================================
-- 2) Severity × lighting conditions
-- =============================================================================
SELECT
  severity_label,
  SUM( (lighting_conditions_label = 'Daylight')::int ) AS daylight,
  SUM( (lighting_conditions_label = 'Twilight')::int ) AS twilight,
  SUM( (lighting_conditions_label = 'Darkness')::int ) AS darkness
FROM fact_accident
WHERE year = 2024
GROUP BY severity_label
ORDER BY severity_label;

-- =============================================================================
-- 3) Severity × road condition (matrix)
-- =============================================================================
SELECT
  severity_label,
  SUM( (road_condition_label = 'Dry')::int ) AS dry,
  SUM( (road_condition_label = 'Wet / damp / slippery')::int ) AS wet_damp_slippery,
  SUM( (road_condition_label = 'Slippery (winter)')::int ) AS winter_slippery
FROM fact_accident
WHERE year = 2024
GROUP BY severity_label
ORDER BY severity_label;

-- =============================================================================
-- 4) Signal metric: share of severe/fatal accidents occurring in darkness
-- =============================================================================
WITH totals AS (
  SELECT COUNT(*) AS n
  FROM fact_accident
  WHERE year = 2024
    AND severity_label IN ('Fatal','Severe injury')
),
dark AS (
  SELECT COUNT(*) AS n
  FROM fact_accident
  WHERE year = 2024
    AND severity_label IN ('Fatal','Severe injury')
    AND lighting_conditions_label = 'Darkness'
)
SELECT
  dark.n AS severe_or_fatal_in_darkness,
  totals.n AS severe_or_fatal_total,
  ROUND(100.0 * dark.n / NULLIF(totals.n,0), 2) AS pct_severe_or_fatal_in_darkness
FROM totals, dark;



