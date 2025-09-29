# Data Sources

## Unfallatlas 2024 (Accident Atlas)
- Source: Statistische Ämter des Bundes und der Länder (Statistical Offices of the Federation and the Länder)  
- Format: CSV (per-year accident data, including Bavaria subset)  
- License: [Data licence Germany – attribution – version 2.0 (dl-de/by-2-0)](https://www.govdata.de/dl-de/by-2-0)  
- Attribution: © Statistische Ämter des Bundes und der Länder, modified by Venkata Sai Swetha Gatamaneni  

Official download portal: [Unfallatlas](https://unfallatlas.statistikportal.de/)  

---

## Gemeindeverzeichnis (Municipality Directory / AGS Codes)
- Source: Destatis (Statistisches Bundesamt)  
- Used to build a lookup table of **7 regions and 94 districts in Bavaria**  
- File included: `data/bavaria_district_lookup_with_regions.csv`  
- Both German and English district/region names added for clarity  

---

## Metadata
- File: `data/Unfallatlas_metadata_EN.pdf` 
- Contains definitions of columns (severity, accident type, lighting conditions, etc.)  
- Based on official explanations from Destatis  

---

## Notes
- This project only uses **Bavaria (state_code = 9)** subset of the Unfallatlas 2024 dataset.  
- Full German datasets are larger and can be obtained from the Unfallatlas portal.  
- All processing (renaming, lookups, translations) was performed by me as part of this portfolio project.
