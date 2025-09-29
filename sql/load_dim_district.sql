\echo == Loading dim_district ==
TRUNCATE dim_district;

-- Column order matches your CSV header
\copy dim_district(
  region_code, region_name_en, region_name_de,
  district_code, district_name_de, district_name_en
) FROM 'data/bavaria_district_lookup_with_regions.csv' CSV HEADER;

-- One-time correction kept here for reproducibility
UPDATE dim_district
SET district_code = 61
WHERE region_code = 1 AND district_code = 11;

-- Quick check
SELECT COUNT(*) AS dim_rows FROM dim_district;