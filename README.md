# Bavaria Traffic Accidents (2024) — SQL Portfolio Project
*A SQL portfolio project exploring accident patterns in Bavaria using real government data (Unfallatlas 2024).*

This project analyzes 2024 road accidents in Bavaria (Germany) using open government data.  
So far, the focus has been on **cleaning, enrichment, and preparing the dataset for SQL analysis**.

##  Completed so far
- Downloaded the Unfallatlas 2024 accident dataset (CSV)
- Filtered to Bavaria (`state_code = 9`)
- Renamed columns into English-friendly names (e.g. `accident_uid`, `severity`, `road_condition`)
- Fixed datatypes
- Built a lookup table for Bavaria’s **7 regions and 94 districts** (German + English names)
- Merged accident data with the lookup → each row now has district + region names
- Verified the lookup with official Destatis sources
- Replaced coded values (severity, accident_type, lighting_conditions, etc.) with human-readable text

---

## 🔜 Next steps
- Import the cleaned dataset into SQL
- Write SQL queries to analyze accident patterns (by district, severity, bicycle involvement, time of day)

---

## 📊 Data
- Unfallatlas 2024 (Bavaria subset, CSV format)  
- District/region lookup from Destatis AGS
- See [`docs/DATA_SOURCES.md`](docs/DATA_SOURCES.md) for licensing  

---

## 📄 License
- Code: MIT (see `LICENSE`)  
- Data: dl-de/by-2-0 (attribution required)
