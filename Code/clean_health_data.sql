WITH standardized AS (
  SELECT
    UPPER(TRIM(FacilityID))                    AS FacilityID,
    TRIM(Region)                               AS Region,
    TRIM(Woreda)                               AS Woreda,
    TRIM(FacilityType)                         AS FacilityType,
    CAST(Year AS INT)                          AS Year,
    CAST(Month AS INT)                         AS Month,
    -- Replace NULLs with 0 for all numeric indicators:
    COALESCE(CAST(HIV_Tested      AS INT), 0)   AS HIV_Tested,
    COALESCE(CAST(HIV_Positive    AS INT), 0)   AS HIV_Positive,
    COALESCE(CAST(ART_Enrollment  AS INT), 0)   AS ART_Enrollment,
    COALESCE(CAST(Viral_Suppression AS INT), 0) AS Viral_Suppression,
    COALESCE(CAST(TB_Screened     AS INT), 0)   AS TB_Screened,
    COALESCE(CAST(TB_Positive     AS INT), 0)   AS TB_Positive,
    COALESCE(CAST(TB_IPT          AS INT), 0)   AS TB_IPT,
    COALESCE(CAST(ANC_Visits      AS INT), 0)   AS ANC_Visits,
    COALESCE(CAST(Deliveries      AS INT), 0)   AS Deliveries,
    COALESCE(CAST(Malaria_Cases   AS INT), 0)   AS Malaria_Cases,
    COALESCE(CAST(Malaria_Deaths  AS INT), 0)   AS Malaria_Deaths,
    COALESCE(CAST(Fully_Immunized AS INT), 0)   AS Fully_Immunized
  FROM raw_health_data
),
deduped AS (
  SELECT DISTINCT *
  FROM standardized
),
validated AS (
  SELECT
    *,
    DATEFROMPARTS(Year, Month, 1) AS ReportingDate
  FROM deduped
  WHERE
      HIV_Tested      >= 0
  AND HIV_Positive    >= 0
  AND ART_Enrollment  >= 0
  AND Viral_Suppression >= 0
  AND TB_Screened     >= 0
  AND TB_Positive     >= 0
  AND TB_IPT          >= 0
  AND ANC_Visits      >= 0
  AND Deliveries      >= 0
  AND Malaria_Cases   >= 0
  AND Malaria_Deaths  >= 0
  AND Fully_Immunized >= 0
)
INSERT INTO clean_health_data (
  FacilityID, Region, Woreda, FacilityType,
  Year, Month, ReportingDate,
  HIV_Tested, HIV_Positive, ART_Enrollment, Viral_Suppression,
  TB_Screened, TB_Positive, TB_IPT,
  ANC_Visits, Deliveries,
  Malaria_Cases, Malaria_Deaths,
  Fully_Immunized
)
SELECT
  FacilityID, Region, Woreda, FacilityType,
  Year, Month, ReportingDate,
  HIV_Tested, HIV_Positive, ART_Enrollment, Viral_Suppression,
  TB_Screened, TB_Positive, TB_IPT,
  ANC_Visits, Deliveries,
  Malaria_Cases, Malaria_Deaths,
  Fully_Immunized
FROM validated;