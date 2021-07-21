SQLite and MIMIC3 specific function library
================
H. David Shea
14 Jul 2021

Connect to the MIMIC3 database - for testing code only

``` r
# base_dir <- here::here("")
# db_file <- fs::path(base_dir, "database/mimic3.db")
# if(dbCanConnect(RSQLite::SQLite(), db_file)) {
#     mimic_db <- dbConnect(RSQLite::SQLite(), db_file)
# } else {
#     stop(str_c("Database file: ", db_file, " not found.", sep=""))
# }
```

Basic SELECT statement wrapper returning results in a tibble

``` r
db_select_data <- function(con, select_statement) {
    res <- dbSendQuery(con, select_statement)
    rval <- tibble::tibble(dbFetch(res))
    dbClearResult(res)
    rm(res)
    rval
}
```

Simple generic SELECT from base tables - note that we do some internal
processing to reflect general usage patterns

``` r
db_get_from_table <- function(con, table, where = NULL) {
    db_select_data(con, str_c("SELECT * FROM", table, where, sep = " ")) %>%
    select(-ROW_ID)  %>%  # default to removing the ROW_ID internal primary key
        mutate(
            # all columns ending in DATE convert to R DateTime
            across(ends_with("DATE"), ymd_hms),
            # all columns ending in TIME convert to R DateTime
            across(ends_with("TIME"), ymd_hms)
        )
}
```

Simple table specific SELECTs from base tables

``` r
db_get_admissions <- function(con, ...) {
    db_get_from_table(con, "admissions", ...)
}

db_get_callout <- function(con, ...) {
    db_get_from_table(con, "callout", ...)
}

db_get_caregivers <- function(con, ...) {
    db_get_from_table(con, "caregivers", ...)
}

db_get_chartevents <- function(con, ...) {
    db_get_from_table(con, "chartevents", ...)
}

db_get_cptevents <- function(con, ...) {
    db_get_from_table(con, "cptevents", ...)
}

db_get_datetimeevents <- function(con, ...) {
    db_get_from_table(con, "datetimeevents", ...)  %>%
        mutate(VALUE = ymd_hms(VALUE)) # VALUE column in DATETIMEEVENTS is a DATE
}

db_get_diagnoses_icd <- function(con, ...) {
    db_get_from_table(con, "diagnoses_icd", ...)
}

db_get_drgcodes <- function(con, ...) {
    db_get_from_table(con, "drgcodes", ...)
}

db_get_d_cpt <- function(con, ...) {
    db_get_from_table(con, "d_cpt", ...)
}

db_get_d_icd_diagnoses <- function(con, ...) {
    db_get_from_table(con, "d_icd_diagnoses", ...)
}

db_get_d_icd_procedures <- function(con, ...) {
    db_get_from_table(con, "d_icd_procedures", ...)
}

db_get_d_items <- function(con, ...) {
    db_get_from_table(con, "d_items", ...)
}

db_get_d_labitems <- function(con, ...) {
    db_get_from_table(con, "d_labitems", ...)
}

db_get_icustays <- function(con, ...) {
    db_get_from_table(con, "icustays", ...)
}

db_get_inputevents_cv <- function(con, ...) {
    db_get_from_table(con, "inputevents_cv", ...)
}

db_get_inputevents_mv <- function(con, ...) {
    db_get_from_table(con, "inputevents_mv", ...)
}

db_get_labevents <- function(con, ...) {
    db_get_from_table(con, "labevents", ...)
}

db_get_microbiologyevents <- function(con, ...) {
    db_get_from_table(con, "microbiologyevents", ...)
}

db_get_noteevents <- function(con, ...) {
    db_get_from_table(con, "noteevents", ...)
}

db_get_outputevents <- function(con, ...) {
    db_get_from_table(con, "outputevents", ...)
}

db_get_patients <- function(con, ...) {
    db_get_from_table(con, "patients", ...)  %>%
        mutate(
            DOB = ymd_hms(DOB),
            DOD = ymd_hms(DOD),
            DOD_HOSP = ymd_hms(DOD_HOSP),
            DOD_SSN = ymd_hms(DOD_SSN)
        ) # DOB and DOD... columns in PATIENTS are DATEs
}

db_get_prescriptions <- function(con, ...) {
    db_get_from_table(con, "prescriptions", ...)
}

db_get_procedureevents_mv <- function(con, ...) {
    db_get_from_table(con, "procedureevents_mv", ...)
}

db_get_procedures_icd <- function(con, ...) {
    db_get_from_table(con, "procedures_icd", ...)
}

db_get_services <- function(con, ...) {
    db_get_from_table(con, "services", ...)
}

db_get_transfers <- function(con, ...) {
    db_get_from_table(con, "transfers", ...)
}
```

Disconnect from the MIMIC3 database - for testing code only

``` r
# dbDisconnect(mimic_db)
```
