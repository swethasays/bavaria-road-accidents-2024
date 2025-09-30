-- Combined overview for lighting and road conditions (counts + %)
-- Purpose: one clean output showing which conditions see the most accidents.
-- Result columns: category (Lighting/Road), condition (label), accidents, pct_of_category

-- =============================================================================
-- Lighting + Road conditions in one result set
-- =============================================================================
WITH lighting AS (
  SELECT 'Lighting'::text AS category,
         lighting_conditions_label AS condition,
         COUNT(*) AS accidents
  FROM fact_accident
  WHERE year = 2024
  GROUP BY lighting_conditions_label
),
road AS (
  SELECT 'Road'::text AS category,
         road_condition_label AS condition,
         COUNT(*) AS accidents
  FROM fact_accident
  WHERE year = 2024
  GROUP BY road_condition_label
),
all_conditions AS (
  SELECT * FROM lighting
  UNION ALL
  SELECT * FROM road
),
totals AS (
  SELECT category, SUM(accidents) AS total
  FROM all_conditions
  GROUP BY category
)
SELECT
  a.category,
  a.condition,
  a.accidents,
  ROUND(100.0 * a.accidents / NULLIF(t.total,0), 2) AS pct_of_category
FROM all_conditions a
JOIN totals t USING (category)
ORDER BY a.category, a.accidents DESC;