\echo == Loading fact_accident ==
TRUNCATE fact_accident;

\copy fact_accident FROM 'data/Bavaria_Accident_Atlas_2024.csv' CSV HEADER;

-- Optional integrity check: all (region_code,district_code) present in dim?
SELECT COUNT(*) AS unmatched
FROM fact_accident f
LEFT JOIN dim_district d USING (region_code, district_code)
WHERE d.region_code IS NULL;


-- Quick row count
SELECT COUNT(*) AS fact_rows FROM fact_accident;