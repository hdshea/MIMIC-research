SQLite and MIMIC3 specific function library
================
H. David Shea

21 Jul 2021

The following routines encapsulate the base level get\_db\_<tables>
routines into higher level concepts with standardized use case patterns.
Some of these were adapted from the [mimic-code github
repository](https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iii).

In the following functions, the concept of a cohort is a group of
subjects identified by numeric SUBJECT\_IDs.

A cohort can be:

-   NULL, indicating the entire mimic-iii population
-   a single SUBJECT\_ID for an indivdual, or
-   a list of SUBJECT\_IDs for a proper subset of the entire population.

``` r
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
```

### Base Concepts Functions

These functions return data frames representing the base concepts used
to define and track patient stays.

Every unique patient in the database

(PKEY `SUBJECT_ID`)

``` r
mimic_get_patients <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_patients(con, where) %>%
        arrange(SUBJECT_ID)
}
```

Every unique hospitalization for each patient in the database

(PKEY `HADM_ID`)

``` r
mimic_get_admissions <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_admissions(con, where) %>%
        arrange(SUBJECT_ID, ADMITTIME, HADM_ID)
}
```

Every unique ICU stay in the database

(PKEY `ICUSTAY_ID`, FKEY `SUBJECT_ID`, `HADM_ID`)

``` r
mimic_get_icustays <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_icustays(con, where) %>%
        arrange(SUBJECT_ID, INTIME, HADM_ID, ICUSTAY_ID)
}
```

Information regarding when a patient was cleared for ICU discharge and
when the patient was actually discharged

(FKEY `SUBJECT_ID`, `HADM_ID`)

``` r
mimic_get_callout <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_callout(con, where) %>%
        arrange(SUBJECT_ID, HADM_ID)
}
```

The clinical service under which a patient is registered

(FKEY `SUBJECT_ID`, `HADM_ID`)

``` r
mimic_get_services <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_services(con, where) %>%
        arrange(SUBJECT_ID, TRANSFERTIME, HADM_ID)
}
```

Patient movement from bed to bed within the hospital, including ICU
admission and discharge

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`)

``` r
mimic_get_transfers <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_transfers(con, where) #%>%
#        arrange(SUBJECT_ID, TRANSFERTIME, HADM_ID)
}
```

### Critical Care Unit Data Functions

These functions return data frames representing the data collected in
the critical care unit.

All charted observations for patients

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)

``` r
mimic_get_chartevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_chartevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

All recorded observations which are dates, for example time of dialysis
or insertion of lines

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)

``` r
mimic_get_datetimeevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_datetimeevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

Intake for patients monitored using the Philips CareVue system while in
the ICU

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)

``` r
mimic_get_inputevents_cv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_inputevents_cv(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

Intake for patients monitored using the iMDSoft Metavision system while
in the ICU

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)

``` r
mimic_get_inputevents_mv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_inputevents_mv(con, where) %>%
        arrange(SUBJECT_ID, STARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

Deidentified notes, including nursing and physician notes, ECG reports,
imaging reports, and discharge summaries

\#’ (FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `CGID`)

``` r
mimic_get_noteevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_noteevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID)
}
```

Output information for patients while in the ICU

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`, `CGID`)

``` r
mimic_get_outputevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_outputevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

Patient procedures for the subset of patients who were monitored in the
ICU using the iMDSoft MetaVision system

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICUSTAY_ID`, `ITEMID`)

``` r
mimic_get_procedureevents_mv <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_procedureevents_mv(con, where) %>%
        arrange(SUBJECT_ID, STARTTIME, HADM_ID, ICUSTAY_ID, ITEMID)
}
```

### EHR Data Functions

These functions return data frames representing data collected in the
hospital record system.

Procedures recorded as Current Procedural Terminology (CPT) codes

(FKEY `SUBJECT_ID`, `HADM_ID`, `CPT_CD`, `CPT_NUMBER`, `CPT_SUFFIX`)

``` r
mimic_get_cptevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_cptevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTDATE, HADM_ID)
}
```

Hospital assigned diagnoses, coded using the International Statistical
Classification of Diseases and Related Health Problems (ICD) system

(FKEY `SUBJECT_ID`, `HADM_ID`, `ICD9_CODE`)

``` r
mimic_get_diagnoses <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_diagnoses_icd(con, where) %>%
        left_join(mimic_get_diagnoses_codes(con), by = "ICD9_CODE") %>%
        arrange(SUBJECT_ID, HADM_ID, SEQ_NUM)
}
```

Diagnosis Related Groups (DRG), which are used by the hospital for
billing purposes.

(FKEY `SUBJECT_ID`, `HADM_ID`)

``` r
mimic_get_drgcodes <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_drgcodes(con, where) %>%
        arrange(SUBJECT_ID, HADM_ID, DRG_TYPE, DRG_CODE)
}
```

Laboratory measurements for patients both within the hospital and in out
patient clinics

``` r
mimic_get_labevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_labevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, ITEMID)
}
```

Microbiology measurements and sensitivities from the hospital database

``` r
mimic_get_microbiologyevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_microbiologyevents(con, where) %>%
        arrange(SUBJECT_ID, CHARTTIME, HADM_ID, SPEC_ITEMID)
}
```

Medications ordered, and not necessarily administered, for a given
patient

``` r
mimic_get_prescriptions <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_prescriptions(con, where) %>%
        arrange(SUBJECT_ID, STARTDATE, HADM_ID, ICUSTAY_ID)
}
```

Patient procedures, coded using the International Statistical
Classification of Diseases and Related Health Problems (ICD) system

``` r
mimic_get_procedures <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    db_get_procedures_icd(con, where) %>%
        left_join(mimic_get_procedures_codes(con), by = "ICD9_CODE") %>%
        arrange(SUBJECT_ID, HADM_ID, SEQ_NUM)
}
```

### Support Data Functions

These functions return data frames descriptive data for some
reference/dictionary tables

Every caregiver who has recorded data in the database

(PKEY `CGID`)

``` r
mimic_get_caregivers <- function(con) {db_get_caregivers(con) %>% arrange(CGID)}
```

Current Procedural Terminology (CPT) codes

``` r
mimic_get_cpt_codes <- function(con) {db_get_d_cpt(con) %>% arrange(SUBSECTIONRANGE)}
```

International Statistical Classification of Diseases and Related Health
Problems (ICD) codes relating to diagnoses

(PKEY `ICD9_CODE`)

``` r
mimic_get_diagnoses_codes <- function(con) {db_get_d_icd_diagnoses(con) %>% arrange(ICD9_CODE)}
```

International Statistical Classification of Diseases and Related Health
Problems (ICD) codes relating to procedures

(PKEY `ICD9_CODE`)

``` r
mimic_get_procedures_codes <- function(con) {db_get_d_icd_procedures(con) %>% arrange(ICD9_CODE)}
```

chartevent items reference

(PKEY `ITEMID`)

``` r
mimic_get_chartevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'chartevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

datetimeevents items reference

(PKEY `ITEMID`)

``` r
mimic_get_datetimeevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'datetimeevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

inputevents\_cv items reference

(PKEY `ITEMID`)

``` r
mimic_get_inputevents_cv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'inputevents_cv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

inputevents\_mv items reference

(PKEY `ITEMID`)

``` r
mimic_get_inputevents_mv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'inputevents_mv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

microbiologyevent items reference

(PKEY `ITEMID`)

``` r
mimic_get_microbiologyevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'microbiologyevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

outputevents items reference

(PKEY `ITEMID`)

``` r
mimic_get_outputevents_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'outputevents'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

procedureevents\_mv items reference

(PKEY `ITEMID`)

``` r
mimic_get_procedureevents_mv_items <- function(con) {
    db_get_d_items(con, where = "where linksto = 'procedureevents_mv'") %>%
        select(-LINKSTO) %>%
        arrange(ITEMID)
}
```

Lab items reference

(PKEY `ITEMID`)

``` r
mimic_get_lab_items <- function(con) {db_get_d_labitems(con) %>% arrange(ITEMID)}
```
