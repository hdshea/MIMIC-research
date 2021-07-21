SQLite and MIMIC3 definitions and useful datasets
================
H. David Shea
30 Jun 2021

Connect to the MIMIC3 database - for testing only

``` r
# base_dir <- here::here("")
# db_file <- fs::path(base_dir, "database/mimic3.db")
# if(dbCanConnect(RSQLite::SQLite(), db_file)) {
#     con <- dbConnect(RSQLite::SQLite(), db_file)
# } else {
#     stop(str_c("Database file: ", db_file, " not found.", sep=""))
# }
```

Meta data for MIMIC-III tables - pulled from edX MITx HST.953x course
material

``` r
mimic3_meta_data <-
    tibble::tribble(
        ~Table.Name,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ~Description, ~Primary.Key,                                          ~Foreign.Key,
        "ADMISSIONS",                                                                                                                                                                                                                                                                                                                                                                                                                              "The ADMISSIONS table gives information regarding a patient’s admission to the hospital. Since each unique hospital visit for a patient is assigned a unique HADM_ID, the ADMISSIONS table can be considered as a definition table for HADM_ID. Information available includes timing information for admission and discharge, demographic information, the source of the admission, and so on.",    "HADM_ID",                                          "SUBJECT_ID",
        "CALLOUT",                                                                                                                                                                                                   "The CALLOUT table provides information about ICU discharge planning. When a patient is deemed ready to leave the ICU, they are “called out”. This process involves: (i) a care provider registering that the patient is ready to leave the ICU and detailing any specialized precautions required, (ii) a coordinator acknowledging the patient requires a bed outside the ward, (iii) a variable period of time in order to coordinate the transfer, and finally (iv) an outcome: either the patient is called out (discharged) or the call out event is canceled. This table provides information for all of the above.",           NA,                                 "SUBJECT_ID, HADM_ID",
        "CAREGIVERS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               "This table provides information regarding care givers. For example, it would define if a care giver is a research nurse (RN), medical doctor (MD), and so on.",       "CGID",                                                    NA,
        "CHARTEVENTS", "CHARTEVENTS contains all the charted data available for a patient. During their ICU stay, the primary repository of a patient’s information is their electronic chart. The electronic chart displays patients’ routine vital signs and any additional information relevant to their care: ventilator settings, laboratory values, code status, mental status, and so on. As a result, the bulk of information about a patient’s stay is contained in CHARTEVENTS. Furthermore, even though laboratory values are captured elsewhere (LABEVENTS), they are frequently repeated within CHARTEVENTS. This occurs because it is desirable to display the laboratory values on the patient’s electronic chart, and so the values are copied from the database storing laboratory values to the database storing the CHARTEVENTS.",           NA,       "SUBJECT_ID, HADM_ID, ICUSTAY_ID, ITEMID, CGID",
        "CPTEVENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "The CPTEVENTS table contains a list of which current procedural terminology codes were billed for which patients. This can be useful for determining if certain procedures have been performed (e.g. ventilation).",           NA, "SUBJECT_ID, HADM_ID, CPT_CD, CPT_NUMBER, CPT_SUFFIX",
        "D_CPT",                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "This table gives some high level information regarding current procedural terminology (CPT) codes. Unfortunately, detailed information for individual codes is unavailable. Unlike all other definition tables, D_CPT does not have a one to one mapping with the corresponding CPT_CD in CPTEVENTS, rather each row of D_CPT maps to a range of CPT_CD.",           NA,                       "SECTIONRANGE, SUBSECTIONRANGE",
        "D_ICD_DIAGNOSES",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        "This table defines International Classification of Diseases Version 9 (ICD-9) codes for diagnoses. These codes are assigned at the end of the patient’s stay and are used by the hospital to bill for care provided.",  "ICD9_CODE",                                                    NA,
        "D_ICD_PROCEDURES",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        "This table defines International Classification of Diseases Version 9 (ICD-9) codes for procedures. These codes are assigned at the end of the patient’s stay and are used by the hospital to bill for care provided. They can further be used to identify if certain procedures have been performed (e.g. surgery).",  "ICD9_CODE",                                                    NA,
        "D_ITEMS",                                                                                                                                                                                                                                                                                                                               "The D_ITEMS table defines ITEMID, which represents measurements in the database. Measurements of the same type (e.g. heart rate) will have the same ITEMID (e.g. 211). The ITEMID column is an alternate primary key to this table: it is unique to each row. Note that the D_ITEMS table is sourced from two ICU databases: Metavision and CareVue. Each system had its own set of ITEMID to identify concepts. As a result, there are multiple ITEMID which correspond to the same concept.",     "ITEMID",                                                    NA,
        "D_LABITEMS",                                                                                                                                                                                                                                                                                                                                                                                             "D_LABITEMS contains definitions for all ITEMID associated with lab measurements in the MIMIC database. All data in LABEVENTS link to the D_LABITEMS table. Each unique LABEL in the hospital database was assigned an ITEMID in this table, and the use of this ITEMID facilitates efficient storage and querying of the data. Note that lab items are kept separate while most definitions are contained in the D_ITEMS table.",     "ITEMID",                                                    NA,
        "DATETIMEEVENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "DATETIMEEVENTS contains all date measurements about a patient in the ICU. For example, the date of last dialysis would be in the DATETIMEEVENTS table, but the systolic blood pressure would not be in this table.",           NA,       "SUBJECT_ID, HADM_ID, ICUSTAY_ID, ITEMID, CGID",
        "DIAGNOSES_ICD",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  "This table contains the ICD9 codes that were attributed to each patient during their stay in the ICU for billing purposes.",           NA,                      "SUBJECT_ID, HADM_ID, ICD9_CODE",
        "DRGCODES",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        "This table contains diagnosis related groups (DRG) codes for patients. HCFA-DRG and MS-DRG codes have multiple descriptions as they have changed over time. Sometimes these descriptions are similar, but sometimes they are completely different diagnoses. Users will need to select rows using both the code and the description.",   "DRG_CODE",                                 "SUBJECT_ID, HADM_ID",
        "ICUSTAYS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              "This table defines each ICUSTAY_ID in the database, i.e. defines a single ICU stay. It is derived from the TRANSFERS table. Specifically, it groups the TRANSFERS table based on ICUSTAY_ID, and excludes rows where no ICUSTAY_ID is present.", "ICUSTAY_ID",                                 "SUBJECT_ID, HADM_ID",
        "INPUTEVENTS_CV",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           "This table has input data for patients under the careview system.",           NA,       "SUBJECT_ID, HADM_ID, ICUSTAY_ID, ITEMID, CGID",
        "INPUTEVENTS_MV",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         "This table has input data for patients under the metavision system.",           NA,       "SUBJECT_ID, HADM_ID, ICUSTAY_ID, ITEMID, CGID",
        "LABEVENTS",                                                                                                                                                                                                                                                                                                                           "The LABEVENTS data contains information regarding laboratory based measurements. The process for acquiring a lab measurement is as follows: first, a member of the clinical staff acquires a fluid from a site in the patient’s body (e.g. blood from an arterial line, urine from a catheter, etc). Next, the fluid is bar coded to associate it with the patient and timestamped to record the time of the fluid acquisition. The lab analyses the data and returns a result within 4-12 hours.",           NA,                         "SUBJECT_ID, HADM_ID, ITEMID",
        "MICROBIOLOGYEVENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  "This table contains microbiology information, including tests performed and sensitivities.",           NA,                         "SUBJECT_ID, HADM_ID, ITEMID",
        "NOTEEVENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 "This table contains all notes for patients.",           NA,                           "SUBJECT_ID, HADM_ID, CGID",
        "OUTPUTEVENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               "This table contains output data for patients.",           NA,       "SUBJECT_ID, HADM_ID, CGID, ICUSTAY_ID, ITEMID",
        "PATIENTS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      "This table contains all charted data for all patients.", "SUBJECT_ID",                                                    NA,
        "PRESCRIPTIONS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   "This table contains medication related order entries, i.e. prescriptions.",           NA,                     "SUBJECT_ID, HADM_ID, ICUSTAY_ID",
        "PROCEDUREEVENTS_MV",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            "This table contains information on procedures performed on patients under the metavision system.",           NA,             "SUBJECT_ID, HADM_ID, ICUSTAY_ID, ITEMID",
        "PROCEDURES_ICD",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "This table contains the ICD9 codes for the procedures performed on the patients for billing purposes.",           NA,                      "SUBJECT_ID, HADM_ID, ICD9_CODE",
        "SERVICES",                                                                                                                                                                                                                                          "The services table describes the service that a patient was admitted under. While a patient can be physicially located at a given ICU type (say MICU), they are not necessarily being cared for by the team which staffs the MICU. This can happen due to a number of reasons, including bed shortage. The SERVICES table should be used if interested in identifying the type of service a patient is receiving in the hospital. For example, if interested in identifying surgical patients, the recommended method is searching for patients admitted under a surgical service.",           NA,                                 "SUBJECT_ID, HADM_ID",
        "TRANFERS",                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   "This table keeps track of the patient's physical location throughout their hospital stay.",           NA,                     "SUBJECT_ID, HADM_ID, ICUSTAY_ID"
    )

# used to replicate the mimi-iii demo set for exercises using those data
demo_subject_ids <-
    "where subject_id in (
        10006, 10011, 10013, 10017, 10019, 10026, 10027, 10029, 10032, 10033,
        10035, 10036, 10038, 10040, 10042, 10043, 10044, 10045, 10046, 10056,
        10059, 10061, 10064, 10065, 10067, 10069, 10074, 10076, 10083, 10088,
        10089, 10090, 10093, 10094, 10098, 10101, 10102, 10104, 10106, 10111,
        10112, 10114, 10117, 10119, 10120, 10124, 10126, 10127, 10130, 10132,
        40124, 40177, 40204, 40277, 40286, 40304, 40310, 40456, 40503, 40595,
        40601, 40612, 40655, 40687, 41795, 41914, 41976, 41983, 42033, 42066,
        42075, 42135, 42199, 42231, 42275, 42281, 42292, 42302, 42321, 42346,
        42367, 42412, 42430, 42458, 43735, 43746, 43748, 43779, 43798, 43827,
        43870, 43879, 43881, 43909, 43927, 44083, 44154, 44212, 44222, 44228)"

# functions for translating ICD9 codes to common diagnoses categories
is_icdd_congestive_heart_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '39891'
`                OR (ICD9_CODE BETWEEN '4280' AND '4289')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_cardiac_arrhythmia <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '42610'
                OR  ICD9_CODE = '42611'
                OR  ICD9_CODE = '42613'
                OR  (ICD9_CODE BETWEEN '4262' AND '42653')
                OR  (ICD9_CODE BETWEEN '4266' AND '42689')
                OR  ICD9_CODE = '4270'
                OR  ICD9_CODE = '4272'
                OR  ICD9_CODE = '42731'
                OR  ICD9_CODE = '42760'
                OR  ICD9_CODE = '4279'
                OR  ICD9_CODE = '7850'
                OR  (ICD9_CODE BETWEEN 'V450' AND 'V4509')
                OR  (ICD9_CODE BETWEEN 'V533' AND 'V5339')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_valvular_disease <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '09320' AND '09324')
                OR  (ICD9_CODE BETWEEN '3940' AND '3971')
                OR  ICD9_CODE = '3979'
                OR  (ICD9_CODE BETWEEN 'V450' AND 'V4509')
                OR  (ICD9_CODE BETWEEN 'V533' AND 'V5339')
                OR  ICD9_CODE = 'V422'
                OR  ICD9_CODE = 'V433'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_pulmonary_circulation_disorder <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '41511' AND '41519')
                OR  (ICD9_CODE BETWEEN '4160' AND '4169')
                OR  ICD9_CODE = '4179'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_peripheral_vascular_disorder <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '4400' AND '4409')
                OR  (ICD9_CODE BETWEEN '44100' AND '4419')
                OR  (ICD9_CODE BETWEEN '4420' AND '4429')
                OR  (ICD9_CODE BETWEEN '4431' AND '4439')
                OR  (ICD9_CODE BETWEEN '44421' AND '44422')
                OR  ICD9_CODE = '4471'
                OR  ICD9_CODE = '449'
                OR  ICD9_CODE = '5571'
                OR  ICD9_CODE = '5579'
                OR  ICD9_CODE = 'V434'"

    icd9_codes <- db_get_d_icd_diagnoses(con = mimic_db, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_uncomplicated <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '4011'
                OR  ICD9_CODE = '4019'
                OR  (ICD9_CODE BETWEEN '64200' AND '64204')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_complicated <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '4010'
                OR  ICD9_CODE = '4372'"

    icd9_codes <- db_get_d_icd_diagnoses(con = mimic_db, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_complicating_pregnancy <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '64220' AND '64224')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_disease_without_heart_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40200'
                OR  ICD9_CODE = '40210'
                OR  ICD9_CODE = '40290'
                OR  ICD9_CODE = '40509'
                OR  ICD9_CODE = '40519'
                OR  ICD9_CODE = '40599'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_disease_with_heart_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40201'
                OR  ICD9_CODE = '40211'
                OR  ICD9_CODE = '40291'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_renal_disease_without_renal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40300'
                OR  ICD9_CODE = '40310'
                OR  ICD9_CODE = '40390'
                OR  ICD9_CODE = '40501'
                OR  ICD9_CODE = '40511'
                OR  ICD9_CODE = '40591'
                OR  (ICD9_CODE BETWEEN '64210' AND '64214')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_renal_disease_with_renal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40301'
                OR  ICD9_CODE = '40311'
                OR  ICD9_CODE = '40391'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_and_renal_disease_without_heart_or_renal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40400'
                OR  ICD9_CODE = '40410'
                OR  ICD9_CODE = '40490'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_and_renal_disease_with_heart_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40401'
                OR  ICD9_CODE = '40411'
                OR  ICD9_CODE = '40491'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_and_renal_disease_with_renal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40402'
                OR  ICD9_CODE = '40412'
                OR  ICD9_CODE = '40492'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_heart_and_renal_disease_with_heart_andrenal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '40403'
                OR  ICD9_CODE = '40413'
                OR  ICD9_CODE = '40493'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypertension_other_in_pregnancy <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '64270' AND '64274')
                OR  (ICD9_CODE BETWEEN '64290' AND '64294')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_paralysis <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '3420' AND '3449')
                OR  (ICD9_CODE BETWEEN '43820' AND '43853')
                OR  ICD9_CODE = '78072'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_other_neurological <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '3300' AND '3319')
                OR  ICD9_CODE = '3320'
                OR  ICD9_CODE = '3334'
                OR  ICD9_CODE = '3335'
                OR  ICD9_CODE = '3337'
                OR  ICD9_CODE IN ('33371','33372','33379','33385','33394')
                OR  (ICD9_CODE BETWEEN '3340' AND '3359')
                OR  ICD9_CODE = '3380'
                OR  ICD9_CODE = '340'
                OR  (ICD9_CODE BETWEEN '3411' AND '3419')
                OR  (ICD9_CODE BETWEEN '34500' AND '34511')
                OR  (ICD9_CODE BETWEEN '3452' AND '3453')
                OR  (ICD9_CODE BETWEEN '34540' AND '34591')
                OR  (ICD9_CODE BETWEEN '34700' AND '34701')
                OR  (ICD9_CODE BETWEEN '34710' AND '34711')
                OR  ICD9_CODE = '3483'
                OR  (ICD9_CODE BETWEEN '64940' AND '64944')
                OR  ICD9_CODE = '7687'
                OR  (ICD9_CODE BETWEEN '76870' AND '76873')
                OR  ICD9_CODE = '7803'
                OR  ICD9_CODE = '78031'
                OR  ICD9_CODE = '78032'
                OR  ICD9_CODE = '78033'
                OR  ICD9_CODE = '78039'
                OR  ICD9_CODE = '78097'
                OR  ICD9_CODE = '7843'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_chronic_pulmonary_disease <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '490' AND '4928')
                OR  (ICD9_CODE BETWEEN '49300' AND '49392')
                OR  (ICD9_CODE BETWEEN '494' AND '4941')
                OR  (ICD9_CODE BETWEEN '4950' AND '505')
                OR  ICD9_CODE = '5064'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_diabetes_without_chronic_complications <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '25000' AND '25033')
                OR  (ICD9_CODE BETWEEN '64800' AND '64804')
                OR  (ICD9_CODE BETWEEN '24900' AND '24931')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_diabetes_with_chronic_complications <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '25040' AND '25093')
                OR  ICD9_CODE = '7751'
                OR  (ICD9_CODE BETWEEN '24940' AND '24991')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hypothyroidism <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '243 ' AND '2442')
                OR  ICD9_CODE = '2448'
                OR  ICD9_CODE = '2449'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_renal_failure <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '585 '
                OR  ICD9_CODE = '5853'
                OR  ICD9_CODE = '5854'
                OR  ICD9_CODE = '5855'
                OR  ICD9_CODE = '5856'
                OR  ICD9_CODE = '5859'
                OR  ICD9_CODE = '586 '
                OR  ICD9_CODE = 'V420'
                OR  ICD9_CODE = 'V451'
                OR  (ICD9_CODE BETWEEN 'V560' AND 'V5632')
                OR  ICD9_CODE = 'V568'
                OR  (ICD9_CODE BETWEEN 'V4511' AND 'V4512')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_liver_disease <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '07022'
                OR  ICD9_CODE = '07023'
                OR  ICD9_CODE = '07032'
                OR  ICD9_CODE = '07033'
                OR  ICD9_CODE = '07044'
                OR  ICD9_CODE = '07054'
                OR  ICD9_CODE = '4560'
                OR  ICD9_CODE = '4561'
                OR  ICD9_CODE = '45620'
                OR  ICD9_CODE = '45621'
                OR  ICD9_CODE = '5710'
                OR  ICD9_CODE = '5712'
                OR  ICD9_CODE = '5713'
                OR  (ICD9_CODE BETWEEN '57140' AND '57149')
                OR  ICD9_CODE = '5715'
                OR  ICD9_CODE = '5716'
                OR  ICD9_CODE = '5718'
                OR  ICD9_CODE = '5719'
                OR  ICD9_CODE = '5723'
                OR  ICD9_CODE = '5728'
                OR  ICD9_CODE = '5735'
                OR  ICD9_CODE = 'V427'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_chronic_peptic_ulcer_disease <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '53141'
                OR  ICD9_CODE = '53151'
                OR  ICD9_CODE = '53161'
                OR  ICD9_CODE = '53170'
                OR  ICD9_CODE = '53171'
                OR  ICD9_CODE = '53191'
                OR  ICD9_CODE = '53241'
                OR  ICD9_CODE = '53251'
                OR  ICD9_CODE = '53261'
                OR  ICD9_CODE = '53270'
                OR  ICD9_CODE = '53271'
                OR  ICD9_CODE = '53291'
                OR  ICD9_CODE = '53341'
                OR  ICD9_CODE = '53351'
                OR  ICD9_CODE = '53361'
                OR  ICD9_CODE = '53370'
                OR  ICD9_CODE = '53371'
                OR  ICD9_CODE = '53391'
                OR  ICD9_CODE = '53441'
                OR  ICD9_CODE = '53451'
                OR  ICD9_CODE = '53461'
                OR  ICD9_CODE = '53470'
                OR  ICD9_CODE = '53471'
                OR  ICD9_CODE = '53491'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_hiv_and_aids <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '042' AND '0449')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_lymphoma <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '20000' AND '20238')
                OR  (ICD9_CODE BETWEEN '20250' AND '20301')
                OR  ICD9_CODE = '2386'
                OR  ICD9_CODE = '2733'
                OR  (ICD9_CODE BETWEEN '20302' AND '20382')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_metastatic_cancer <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '1960' AND '1991')
                OR  (ICD9_CODE BETWEEN '20970' AND '20975')
                OR  ICD9_CODE = '20979'
                OR  ICD9_CODE = '78951'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}



is_icdd_solid_tumor_without_metastasis <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '1400' AND '1729')
                OR  (ICD9_CODE BETWEEN '1740' AND '1759')
                OR  (ICD9_CODE BETWEEN '179' AND '1958')
                OR  (ICD9_CODE BETWEEN '20900' AND '20924')
                OR  (ICD9_CODE BETWEEN '20925' AND '2093')
                OR  (ICD9_CODE BETWEEN '20930' AND '20936')
                OR  (ICD9_CODE BETWEEN '25801' AND '25803')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}


is_icdd_rheumatoid_arthritis <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '7010'
                OR  (ICD9_CODE BETWEEN '7100' AND '7109')
                OR  (ICD9_CODE BETWEEN '7140' AND '7149')
                OR  (ICD9_CODE BETWEEN '7200' AND '7209')
                OR  ICD9_CODE = '725'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_coagulation_deficiency <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '2860' AND '2869')
                OR  ICD9_CODE = '2871'
                OR  (ICD9_CODE BETWEEN '2873' AND '2875')
                OR  (ICD9_CODE BETWEEN '64930' AND '64934')
                OR  ICD9_CODE = '28984'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_obesity <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '2780'
                OR  ICD9_CODE = '27800'
                OR  ICD9_CODE = '27801'
                OR  ICD9_CODE = '27803'
                OR  (ICD9_CODE BETWEEN '64910' AND '64914')
                OR  (ICD9_CODE BETWEEN 'V8530' AND 'V8539')
                OR  ICD9_CODE = 'V854'
                OR  (ICD9_CODE BETWEEN 'V8541' AND 'V8545')
                OR  ICD9_CODE = 'V8554'
                OR  ICD9_CODE = '79391'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_weight_loss <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '260 ' AND '2639')
                OR  (ICD9_CODE BETWEEN '78321' AND '78322')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_Fluid_and_electrolyte_disorders <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '2760' AND '2769')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_blood_loss_anemia <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '2800'
                OR  (ICD9_CODE BETWEEN '64820' AND '64824')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_deficiency_anemias <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '2801' AND '2819')
                OR  (ICD9_CODE BETWEEN '28521' AND '28529')
                OR  ICD9_CODE = '2859'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_alcohol_abuse <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '2910' AND '2913')
                OR  ICD9_CODE = '2915'
                OR  ICD9_CODE = '2918'
                OR  ICD9_CODE = '29181'
                OR  ICD9_CODE = '29182'
                OR  ICD9_CODE = '29189'
                OR  ICD9_CODE = '2919'
                OR  (ICD9_CODE BETWEEN '30300' AND '30393')
                OR  (ICD9_CODE BETWEEN '30500' AND '30503')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_drug_abuse <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '2920'
                OR  (ICD9_CODE BETWEEN '29282' AND '29289')
                OR  ICD9_CODE = '2929'
                OR  (ICD9_CODE BETWEEN '30400' AND '30493')
                OR  (ICD9_CODE BETWEEN '30520' AND '30593')
                OR  (ICD9_CODE BETWEEN '64830' AND '64834')"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_psychoses <- function( code, con ) {
    where <- "WHERE (ICD9_CODE BETWEEN '29500' AND '2989')
                OR  ICD9_CODE = '29910'
                OR  ICD9_CODE = '29911'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

is_icdd_depression <- function( code, con ) {
    where <- "WHERE ICD9_CODE = '3004'
                OR  ICD9_CODE = '30112'
                OR  ICD9_CODE = '3090'
                OR  ICD9_CODE = '3091'
                OR  ICD9_CODE = '311'"

    icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)

    code %in% icd9_codes
}

# # is_icdd_ template
# is_icdd_ <- function( code, con ) {
#     where <- "WHERE "
#
#     icd9_codes <- db_get_d_icd_diagnoses(con = con, where = where) %>% pull(ICD9_CODE)
#
#     code %in% icd9_codes
# }
```
