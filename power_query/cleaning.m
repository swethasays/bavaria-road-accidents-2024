let
  Source = Csv.Document(File.Contents("/Users/swetha/Downloads/csv/Unfallorte2024_LinRef.csv"), [Delimiter = ";", Columns = 26, Encoding = 65001]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Renamed columns" = Table.RenameColumns(#"Promoted headers", {{"OID_", "row_id"}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Renamed columns", {{"row_id", Int64.Type}, {"UIDENTSTLAE", type text}, {"ULAND", Int64.Type}, {"UREGBEZ", Int64.Type}, {"UKREIS", Int64.Type}, {"UGEMEINDE", Int64.Type}, {"UJAHR", Int64.Type}, {"UMONAT", Int64.Type}, {"USTUNDE", Int64.Type}, {"UWOCHENTAG", Int64.Type}, {"UKATEGORIE", Int64.Type}, {"UART", Int64.Type}, {"UTYP1", Int64.Type}, {"ULICHTVERH", Int64.Type}, {"IstStrassenzustand", Int64.Type}, {"IstRad", Int64.Type}, {"IstPKW", Int64.Type}, {"IstFuss", Int64.Type}, {"IstKrad", Int64.Type}, {"IstGkfz", Int64.Type}, {"IstSonstige", Int64.Type}, {"LINREFX", type number}, {"LINREFY", type number}, {"XGCSWGS84", Int64.Type}, {"YGCSWGS84", Int64.Type}, {"PLST", Int64.Type}}),
  #"Renamed columns 1" = Table.RenameColumns(#"Changed column type", {{"UIDENTSTLAE", "accident_uid"}, {"ULAND", "state_code"}, {"UREGBEZ", "region_code"}, {"UKREIS", "district_code"}, {"UGEMEINDE", "municipality_code"}, {"UJAHR", "year"}, {"UMONAT", "month"}, {"USTUNDE", "hour"}, {"UWOCHENTAG", "weekday"}, {"UKATEGORIE", "severity"}, {"UART", "accident_type"}, {"UTYP1", "accident_situation"}, {"ULICHTVERH", "lighting_conditions"}, {"IstStrassenzustand", "road_condition"}, {"IstRad", "is_bicycle"}, {"IstPKW", "is_car"}, {"IstFuss", "is_pedestrian"}, {"IstKrad", "is_motorcycle"}, {"IstGkfz", "is_goods_vehicle"}, {"IstSonstige", "is_other_vehicle"}}),
  #"Removed columns" = Table.RemoveColumns(#"Renamed columns 1", {"LINREFX", "LINREFY"}),
  #"Renamed columns 2" = Table.RenameColumns(#"Removed columns", {{"XGCSWGS84", "longitude"}, {"YGCSWGS84", "latitude"}, {"PLST", "police_station_code"}}),
  #"Removed columns 1" = Table.RemoveColumns(#"Renamed columns 2", {"row_id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Removed columns 1", {{"accident_uid", type text}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type 1", each ([state_code] = 9)),
  #"Added custom" = Table.AddColumn(#"Filtered rows", "severity_label", each if [severity] = 1 then "Fatal"
else if [severity] = 2 then "Severe injury"
else if [severity] = 3 then "Slight injury"
else null),
  #"Added custom 1" = Table.AddColumn(#"Added custom", "weekday_label", each if [weekday] = 1 then "Sunday"
else if [weekday] = 2 then "Monday"
else if [weekday] = 3 then "Tuesday"
else if [weekday] = 4 then "Wednesday"
else if [weekday] = 5 then "Thursday"
else if [weekday] = 6 then "Friday"
else if [weekday] = 7 then "Saturday"
else null),
  #"Added custom 2" = Table.AddColumn(#"Added custom 1", "Customaccident_type_label", each if [accident_type] = 1 then "Collision: starting/stopping vehicle"
else if [accident_type] = 2 then "Collision: moving ahead / waiting"
else if [accident_type] = 3 then "Collision: lateral same direction"
else if [accident_type] = 4 then "Collision: oncoming vehicle"
else if [accident_type] = 5 then "Collision: turning/crossing vehicle"
else if [accident_type] = 6 then "Collision: pedestrian"
else if [accident_type] = 7 then "Collision: obstacle in carriageway"
else if [accident_type] = 8 then "Leaving road right"
else if [accident_type] = 9 then "Leaving road left"
else if [accident_type] = 0 then "Other kind"
else null),
  #"Added custom 3" = Table.AddColumn(#"Added custom 2", "accident_situation_label", each if [accident_situation] = 1 then "Driving accident"
else if [accident_situation] = 2 then "Turning off road"
else if [accident_situation] = 3 then "Turning into / crossing road"
else if [accident_situation] = 4 then "Pedestrian crossing"
else if [accident_situation] = 5 then "Stationary accident"
else if [accident_situation] = 6 then "Same carriageway accident"
else if [accident_situation] = 7 then "Other accident"
else null),
  #"Added custom 4" = Table.AddColumn(#"Added custom 3", "lighting_conditions_label", each if [lighting_conditions] = 0 then "Daylight"
else if [lighting_conditions] = 1 then "Twilight"
else if [lighting_conditions] = 2 then "Darkness"
else null),
  #"Added custom 5" = Table.AddColumn(#"Added custom 4", "road_condition_label", each if [road_condition] = 0 then "Dry"
else if [road_condition] = 1 then "Wet / damp / slippery"
else if [road_condition] = 2 then "Slippery (winter)"
else null),
  #"Added custom 6" = Table.AddColumn(#"Added custom 5", "car", each if [is_car] = 1 then "Yes" else "No"),
  #"Added custom 7" = Table.AddColumn(#"Added custom 6", "pedestrain", each if [is_pedestrian] = 1 then "Yes" else "No"),
  #"Added custom 8" = Table.AddColumn(#"Added custom 7", "bicycle", each if [is_bicycle] = 1 then "Yes" else "No"),
  #"Added custom 9" = Table.AddColumn(#"Added custom 8", "motorcycle", each if [is_motorcycle] = 1 then "Yes" else "No"),
  #"Added custom 10" = Table.AddColumn(#"Added custom 9", "goods_vehicle", each if [is_goods_vehicle] = 1 then "Yes" else "No"),
  #"Added custom 11" = Table.AddColumn(#"Added custom 10", "other_vehicle", each if [is_other_vehicle] = 1 then "Yes" else "No"),
  #"Added custom 12" = Table.AddColumn(#"Added custom 11", "region_name", each if [region_code] = 1 then "Upper Bavaria"
else if [region_code] = 2 then "Lower Bavaria"
else if [region_code] = 3 then "Upper Palatinate"
else if [region_code] = 4 then "Upper Franconia"
else if [region_code] = 5 then "Middle Franconia"
else if [region_code] = 6 then "Lower Franconia"
else if [region_code] = 7 then "Swabia"
else null),
  #"Merged queries" = Table.NestedJoin(#"Added custom 12", {"region_code", "district_code"}, bavaria_district_lookup_with_regions, {"region_code", "district_code"}, "bavaria_district_lookup_with_regions", JoinKind.LeftOuter),
  #"Expanded bavaria_district_lookup_with_regions" = Table.ExpandTableColumn(#"Merged queries", "bavaria_district_lookup_with_regions", {"region_name_en", "region_name_de", "district_name_de", "district_name_en"}, {"region_name_en", "region_name_de", "district_name_de", "district_name_en"})
in
  #"Expanded bavaria_district_lookup_with_regions"
