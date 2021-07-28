#' ---
#' title: "SQLite and MIMIC3 specific function library"
#' author: "H. David Shea\n"
#' date: "`r format(Sys.time(), '%d %b %Y')`"
#' output: github_document
#' ---
#'
#+ r setup, include = FALSE
library(DBI)
library(RSQLite)
library(tidyverse)
library(lubridate)
library(Hmisc)
#+

#+ r db_con, include = FALSE
# Connect to the MIMIC3 database - for testing code only
#
# base_dir <- here::here("")
# db_dir <- fs::path(base_dir, "database")
# db_file <- fs::path(db_dir, "mimic3.db")
#
# if(dbCanConnect(RSQLite::SQLite(), db_file)) {
#     mimic3 <- dbConnect(RSQLite::SQLite(), db_file)
# } else {
#     stop(str_c("Database file: ", db_file, " not found.", sep = ""))
# }
#+

#+ r aux_func, include = FALSE
base_dir <- here::here("")
source(fs::path(base_dir, "mimic_concepts/db_functions.R"))
source(fs::path(base_dir, "mimic_concepts/mimic3_meta_data.R"))
#+

#'
#' The following routines encapsulate the base level get_db_<tables> routines into higher level concepts
#' with standardized use case patterns.  Some of these were adapted from the
#' [mimic-code github repository](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iii).
#'
#' In the following functions, the concept of a cohort is a group of subjects identified by numeric SUBJECT_IDs.
#'
#' A cohort can be:
#'
#' * NULL, indicating the entire mimic-iii population
#' * a single SUBJECT_ID for an indivdual, or
#' * a list of SUBJECT_IDs for a proper subset of the entire population.
#'
#+ r cohort_where
cohort_where <- function(cohort) {
    rval <- NULL
    if(!is.null(cohort)) {
        rval <- ifelse(
            length(cohort) == 1,
            str_c("WHERE SUBJECT_ID = ", cohort),
            str_c("WHERE SUBJECT_ID IN (", str_c(cohort, collapse = ", "), ")")
        )
    }

    rval
}
#+

#'
#' In the following functions, the concept of an item list is a group of event items identified by numeric ITEMIDs.
#'
#' A item list can be:
#'
#' * NULL, indicating the every item
#' * a single ITEMID for an individual ITEMID, or
#' * a list of ITEMIDs for a proper subset of the eveny items.
#'
#+ r itemlist_where
itemlist_where <- function(itemlist) {
    rval <- NULL
    if(!is.null(itemlist)) {
        rval <- ifelse(
            length(itemlist) == 1,
            str_c("WHERE ITEMID = ", itemlist),
            str_c("WHERE ITEMID IN (", str_c(itemlist, collapse = ", "), ")")
        )
    }

    rval
}
#+

#' ### Base Concepts Functions
#'
#' These functions return data frames representing the base concepts used to define and track patient stays.
#'

#+ r base_concepts
#' Every unique patient in the database
#'
#' (PKEY `SUBJECT_ID`)
#'
mimic_get_patients <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_patients(con, where) %>%
        arrange(SUBJECT_ID)
}

#' Every unique hospitalization for each patient in the database
#'
#' (PKEY `HADM_ID`)
#'
mimic_get_admissions <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_admissions(con, where) %>%
        arrange(SUBJECT_ID, ADMITTIME, HADM_ID)
}

#' Every unique ICU stay in the database
#'
#' (PKEY `ICUSTAY_ID`, FKEY `SUBJECT_ID`, `HADM_ID`)
#'
mimic_get_icustays <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_icustays(con, where) %>%
        arrange(SUBJECT_ID, INTIME, HADM_ID, ICUSTAY_ID)
}

#' Information regarding when a patient was cleared for ICU discharge and when the patient was actually discharged
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`)
#'
mimic_get_callout <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_callout(con, where) %>%
        arrange(SUBJECT_ID, HADM_ID)
}

#' The clinical service under which a patient is registered
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`)
#'
mimic_get_services <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_services(con, where) %>%
        arrange(SUBJECT_ID, TRANSFERTIME, HADM_ID) %>%
        group_by(SUBJECT_ID, HADM_ID) %>%
        mutate(
            SERVICE_SEQ = row_number(),
            FIRST_SERVICE = (SERVICE_SEQ == 1)
        ) %>%
        ungroup()
}

#' Patient movement from bed to bed within the hospital, including ICU admission and discharge
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`)
#'
mimic_get_transfers <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_transfers(con, where) #%>%
#        arrange(SUBJECT_ID, TRANSFERTIME, HADM_ID)
}
#+

#+ r ccu_data
#' ### Critical Care Unit Data Functions
#'
#' These functions return data frames representing the data collected in the critical care unit.
#'

#' All charted observations for patients
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)
#'
mimic_get_chartevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
    cwhere <- cohort_where(cohort)
    iwhere <- itemlist_where(itemlist)
    if (!is.null(cwhere) && !is.null(iwhere)) {
        iwhere <- str_replace(iwhere, '^WHERE', ' AND')
    }
    where <- str_c(cwhere, iwhere)

    db_get_chartevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}

#' All recorded observations which are dates, for example time of dialysis or insertion of lines
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)
#'
mimic_get_datetimeevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_datetimeevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}

#' Intake for patients monitored using the Philips CareVue system while in the ICU
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)
#'
mimic_get_inputevents_cv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_inputevents_cv(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}

#' Intake for patients monitored using the iMDSoft Metavision system while in the ICU
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)
#'
mimic_get_inputevents_mv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_inputevents_mv(con, where) %>%
        arrange(SUBJECT_ID, STARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}

#' Deidentified notes, including nursing and physician notes, ECG reports, imaging reports, and discharge summaries
#'
#'#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `CGID`)
#'
mimic_get_noteevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_noteevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID)
}

#' Output information for patients while in the ICU
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)
#'
mimic_get_outputevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_outputevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}

#' Patient procedures for the subset of patients who were monitored in the ICU using the iMDSoft MetaVision system
#'
#' (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`)
#'
mimic_get_procedureevents_mv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_procedureevents_mv(con, where) %>%
        arrange(SUBJECT_ID, STARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
#+

#' ### EHR Data Functions
#'
#' These functions return data frames representing data collected in the hospital record system.
#'

#+ r ehr_data
#' Procedures recorded as Current Procedural Terminology (CPT) codes
#'
#'  (FKEY `SUBJECT_ID`, `HADM_ID`, `CPT_CD`, `CPT_NUMBER`, `CPT_SUFFIX`)
#'
mimic_get_cptevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_cptevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTDATE, HADM_ID)
}

#' Hospital assigned diagnoses, coded using the International Statistical Classification of Diseases and Related Health Problems (ICD) system
#'
#'  (FKEY `SUBJECT_ID`, `HADM_ID`, `ICD9_CODE`)
#'
mimic_get_diagnoses <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_diagnoses_icd(con, where) %>%
        left_join(mimic_get_diagnoses_codes(con), by = "ICD9_CODE") %>%
        arrange(SUBJECT_ID, HADM_ID, SEQ_NUM)
}

#' Diagnosis Related Groups (DRG), which are used by the hospital for billing purposes.
#'
#'  (FKEY `SUBJECT_ID`, `HADM_ID`)
#'
mimic_get_drgcodes <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_drgcodes(con, where) %>%
        arrange(SUBJECT_ID, HADM_ID, DRG_TYPE, DRG_CODE)
}

#' Laboratory measurements for patients both within the hospital and in out patient clinics
#'
mimic_get_labevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
    cwhere <- cohort_where(cohort)
    iwhere <- itemlist_where(itemlist)
    if(!is.null(cwhere) && !is.null(iwhere)) {
        iwhere <- str_replace(iwhere, '^WHERE', ' AND')
    }
    where <- str_c(cwhere, iwhere)

    db_get_labevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ITEMID)
}

#' Microbiology measurements and sensitivities from the hospital database
#'
mimic_get_microbiologyevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_microbiologyevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, SPEC_ITEMID)
}

#' Medications ordered, and not necessarily administered, for a given patient
#'
mimic_get_prescriptions <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_prescriptions(con, where) %>%
        arrange(SUBJECT_ID, STARTDATE, HADM_ID, ICUSTAY_ID)
}

#' Patient procedures, coded using the International Statistical Classification of Diseases and Related Health Problems (ICD) system
#'
mimic_get_procedures <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_procedures_icd(con, where) %>%
        left_join(mimic_get_procedures_codes(con), by = "ICD9_CODE") %>%
        arrange(SUBJECT_ID, HADM_ID, SEQ_NUM)
}
#+

#' ### Support Data Functions
#'
#' These functions return data frames descriptive data for some reference/dictionary tables
#'

#+ r support_data
#' Every caregiver who has recorded data in the database
#'
#' (PKEY `CGID`)
#'
mimic_get_caregivers <- function(con) {db_get_caregivers(con) %>% arrange(CGID)}

#' Current Procedural Terminology (CPT) codes
#'
mimic_get_cpt_codes <- function(con) {db_get_d_cpt(con) %>% arrange(SUBSECTIONRANGE)}

#' International Statistical Classification of Diseases and Related Health Problems (ICD) codes
#' relating to diagnoses
#'
#' (PKEY `ICD9_CODE`)
#'
mimic_get_diagnoses_codes <- function(con) {db_get_d_icd_diagnoses(con) %>% arrange(ICD9_CODE)}

#' International Statistical Classification of Diseases and Related Health Problems (ICD) codes
#' relating to procedures
#'
#' (PKEY `ICD9_CODE`)
#'
mimic_get_procedures_codes <- function(con) {db_get_d_icd_procedures(con) %>% arrange(ICD9_CODE)}

#' chartevent items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_chartevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'chartevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' datetimeevents items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_datetimeevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'datetimeevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' inputevents_cv items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_inputevents_cv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'inputevents_cv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' inputevents_mv items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_inputevents_mv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'inputevents_mv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' microbiologyevent items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_microbiologyevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'microbiologyevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' outputevents items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_outputevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'outputevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' procedureevents_mv items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_procedureevents_mv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'procedureevents_mv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}

#' Lab items reference
#'
#' (PKEY `ITEMID`)
#'
mimic_get_lab_items <- function(con) {db_get_d_labitems(con) %>% arrange(ITEMID)}
#+

#' ### Common Pattern Functions
#'
#' These functions return data frames representing common patterns of data access for research.
#'

#' Combined patient and admissions data.  The function calculates as part of the data frame
#' length of stay in the hospital in days (`LOS_HOSPITAL`) and age at admission in years (`ADMISSION_AGE`).
#' Patients who are older than 89 years old at any time in the database have had their date of birth
#' shifted to obscure their age and comply with HIPAA.  These ages appear in the data as >= 300.
#' As such, an additional field is added to categorize age into decades (`ADMISSION_DECADE`).
#' Patients older than 89 show up in the 90 and older age decade bucket.
#'
#' This is patterned off the `icustay_detail` SQL in the mimic-code github repository referenced above.
#'
mimic_get_patient_admissions <- function(con, cohort = NULL, ...) {
    mimic_get_admissions(con, cohort) %>%
        left_join(mimic_get_patients(con, cohort), by = "SUBJECT_ID") %>%
        mutate(
            LOS_HOSPITAL = time_length(difftime(DISCHTIME, ADMITTIME), "days"),
            ADMISSION_AGE = time_length(difftime(ADMITTIME, DOB), "years"),
            ADMISSION_DECADE = cut2(ADMISSION_AGE,c(0,10,20,30,40,50,60,70,80,90)),
            ETHNICITY_GROUP =
                case_when(
                    str_starts(ETHNICITY, 'WHITE') ~ 'WHITE',
                    str_starts(ETHNICITY, 'BLACK') ~ 'BLACK',
                    str_starts(ETHNICITY, 'CARIBBEAN') ~ 'BLACK',
                    str_starts(ETHNICITY, 'HISPANIC') ~ 'HISPANIC',
                    str_starts(ETHNICITY, 'ASIAN') ~ 'ASIAN',
                    str_starts(ETHNICITY, 'AMERICAN INDIAN') ~ 'NATIVE',
                    str_starts(ETHNICITY, 'UNKNOWN') ~ 'UNKNOWN',
                    str_starts(ETHNICITY, 'UNABLE') ~ 'UNKNOWN',
                    str_starts(ETHNICITY, 'PATIENT') ~ 'UNKNOWN',
                    TRUE ~ 'OTHER'
                ),
            ETHNICITY_GROUP = as.factor(ETHNICITY_GROUP),
            ADMISSION_TYPE = as.factor(ADMISSION_TYPE),
            ADMISSION_LOCATION = as.factor(ADMISSION_LOCATION),
            DISCHARGE_LOCATION = as.factor(DISCHARGE_LOCATION),
            INSURANCE = as.factor(INSURANCE)
            ) %>%
        arrange(SUBJECT_ID, ADMITTIME) %>%
        group_by(SUBJECT_ID) %>%
        mutate(
            ADMISSION_SEQ = row_number(),
            FIRST_ADMISSION = (ADMISSION_SEQ == 1)
        ) %>%
        ungroup() %>%
        select(SUBJECT_ID, HADM_ID,
               GENDER, DOD,
               ADMISSION_SEQ, FIRST_ADMISSION, ADMITTIME, DISCHTIME, LOS_HOSPITAL,
               ADMISSION_AGE, ADMISSION_DECADE,
               ADMISSION_TYPE, ADMISSION_LOCATION, DISCHARGE_LOCATION,
               INSURANCE, ETHNICITY_GROUP, HAS_CHARTEVENTS_DATA)
}

#' Combined patient, admission and icu stay data.  This includes all of the information from the
#' `mimic_get_patient_admissions` function plus addition data on icu stays while in the hospital.
#'
#' This is patterned off the `icustay_detail` SQL in the mimic-code github repository referenced above.
#'
mimic_get_patient_icustays <- function(con, cohort = NULL, ...) {
    mimic_get_icustays(con, cohort) %>%
        left_join(mimic_get_patient_admissions(con, cohort), by = c("SUBJECT_ID", "HADM_ID")) %>%
        arrange(SUBJECT_ID, INTIME) %>%
        group_by(SUBJECT_ID, HADM_ID) %>%
        mutate(
            ICUSTAY_SEQ = row_number(),
            FIRST_ICUSTAY = (ICUSTAY_SEQ == 1),
            LOS_ICUSTAY = LOS
        ) %>%
        ungroup() %>%
        select(SUBJECT_ID, HADM_ID, ICUSTAY_ID,
               GENDER, DOD,
               ADMISSION_SEQ, FIRST_ADMISSION, ADMITTIME, DISCHTIME, LOS_HOSPITAL,
               ADMISSION_AGE, ADMISSION_DECADE,
               ADMISSION_TYPE, ADMISSION_LOCATION, DISCHARGE_LOCATION,
               INSURANCE, ETHNICITY_GROUP, HAS_CHARTEVENTS_DATA,
               ICUSTAY_SEQ, FIRST_ICUSTAY, INTIME, OUTTIME, LOS_ICUSTAY)
}

#+ r db_discon, include = FALSE
# Disconnect from the MIMIC3 database - for testing code only
#
#dbDisconnect(mimic3)
#+
