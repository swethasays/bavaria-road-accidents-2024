# Bavaria Traffic Accidents (2024) — SQL Portfolio Project
This project analyzes 2024 road accidents in Bavaria (Germany) using SQL.  
It demonstrates a realistic data pipeline: **open data → cleaning (Power Query) → dimensional modeling → SQL insights**.

## Why this project
- Real public data (Unfallatlas 2024, free under dl-de/by-2-0)
- Location-aware insights (district + region names)
- Shows SQL, data cleaning, and reporting skills

## Data
- Unfallatlas 2024 CSV (Bavaria subset)
- District/region lookup (from Destatis AGS)
- See [`docs/DATA_SOURCES.md`](docs/DATA_SOURCES.md) for licensing

## Pipeline
1. **Cleaning (Power Query)**  
   - Rename columns, fix datatypes  
   - Filter Bavaria  
   - Merge with district lookup  
   - Add readable labels for severity, accident type, etc.

2. **SQL schema**  


3. **Analysis queries**  


## Dimensional model


## License
- Code: MIT (see `LICENSE`)  
- Data: dl-de/by-2-0 (attribution required, see `docs/DATA_SOURCES.md`)
