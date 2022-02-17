library(tidyverse)
library(lubridate)
library(parsedate)
library(here)

nuts <- read_csv(here('original_data', "Hunt IYS 2020 Nuts.csv")) %>% 
  select(-"Sample type", - "Sample ID...2", "Sample ID" = "Sample ID...12") %>% 
  mutate(cruise = "GoA2020",
         station = paste0("GoA2020:", "Stn", Station),
    eventDate = ymd_hms(paste(Date, Time, sep = '-'), tz = "America/Vancouver"),
         dateTime = format_iso_8601(as.POSIXct(eventDate,
                                                       format = "%Y-%m-%d %H:%M%:S",
                                                       tz="America/Vancouver")),
         dateTime = str_replace(dateTime, "\\+00:00", "Z"),
         dateTime2 = ymd_hms(dateTime),
         year = year(dateTime2),
         month = month(dateTime2),
         day = day(dateTime2),
         time = hms::as_hms(dateTime2),
         timezone = "UTC"
  ) %>% 
  select(cruise, station, dateTime, year, month, day, time, timezone, 
         latitude = Latitude,
         longitude = Longitude,
         sample_depth = `Sample depth`,
         volume_filtered = `Volume filtered`,
         sample_ID = `Sample ID`,
         `PO4(µM)`,
         `SiO2(µM)`,
         "NO3+NO2(µM)",
         date_analyzed = "Date Analyzed",
         notes = Notes)

write_csv(nuts, here("standardized_data", "2020_IYS_nuts.csv"))

