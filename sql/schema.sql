CREATE TABLE dim_district (
    region_code INT NOT NULL,
    district_code INT NOT NULL,
    region_name_en TEXT,
    region_name_de TEXT,
    district_name_en TEXT,
    district_name_de TEXT,
    PRIMARY KEY (region_code,district_code)
);



DROP TABLE IF EXISTS fact_accident;

CREATE TABLE fact_accident (
    accident_uid TEXT PRIMARY KEY,
    state_code INT,
    region_code INT,
    district_code INT,
    municipality_code INT,
    year INT,
    month INT,
    hour INT,
    weekday INT,
    severity INT,
    accident_type INT,
    accident_situation INT,
    lighting_conditions INT,
    road_condition INT,
    is_bicycle INT,
    is_car INT,
    is_pedestrian INT,
    is_motorcycle INT,
    is_goods_vehicle INT,
    is_other_vehicle INT,
    longitude TEXT,
    latitude TEXT,
    police_station_code INT,
    severity_label TEXT,
    weekday_label TEXT,
    Customaccident_type_label TEXT,
    accident_situation_label TEXT,
    lighting_conditions_label TEXT,
    road_condition_label TEXT,
    car TEXT,
    pedestrain TEXT,
    bicycle TEXT,
    motorcycle TEXT,
    goods_vehicle TEXT,
    other_vehicle TEXT,
    region_name TEXT,
    region_name_en TEXT,
    region_name_de TEXT,
    district_name_de TEXT,
    district_name_en TEXT,
    FOREIGN KEY (region_code, district_code)
        REFERENCES dim_district(region_code, district_code)
);