---
title: 'MIMIC-III Population Statistics'
author: "H. David Shea"
date: "23 Jul 2021"
output:
    html_document:
        theme: spacelab
        code_folding: hide
        keep_md: true
---
    


# {.tabset .tabset-fade}

## Data sets

This work references data on from the Medical Information Mart for Intensive Care MIMIC-III database v1.4.  MIMIC-III is a large, freely-available database comprising de-identified health-related data from patients who were admitted to the critical care units of the Beth Israel Deaconess Medical Center from 2001-2019.  Detailed information can be obtained on the [MIMIC-III website](https://mimic.mit.edu/docs/iii/).

I have in *mimic_base_dir*/database/mimic3.db the SQLite version of the full MIMIC-III v1.4 database loaded.  I'll use that in the processing below. The following code chunk attaches the database and loads auxiliary functions (available in *mimic_base_dir*/mimic_concepts).


```r
base_dir <- here::here("")
db_file <- fs::path(base_dir, "database/mimic3.db")
if(dbCanConnect(RSQLite::SQLite(), db_file)) {
    mimic3 <- dbConnect(RSQLite::SQLite(), db_file)
} else {
    stop(str_c("Database file: ", db_file, " not found.", sep=""))
}

source(fs::path(base_dir, "mimic_concepts/mimic_concepts.R"))
```

The primary dataset used in the analysis is the full adult population (age >= 16) from the MIMIC-III database. This data set includes patient demographics data, data about each admission for the patient, and data about any ICU stays while the patient was admitted to the hospital.


```r
pat_icu <- mimic_get_patient_icustays(mimic3) %>% 
    filter(ADMISSION_AGE >= 16)
```



The `pat_icu` dataset contains information on 38,597 patients (23,144 men and 17,626 women), 49,785 individual hospital admissions, and 53,423 individual ICU stays.

Individual patients were admitted to the hospital between 1 and 41 times with the average number of admission being 1.3.  The average length of hospital stays was 10 days.

Per admission, patients were admitted to intensive care between 1 and 7 times with the average number of ICU stays per admission being 1.1.  The average length of an ICU stay was 4.1 days.

## Basic Patient Demographics {.tabset .tabset-fade .tabset-pills}

### Age



The average age of patients at the time of admission was 74.84 - for men the average was 69.83 and for women the average was 81.27.

Note:  Patients who are older than 89 years old at any time in the database have had their date of birth
shifted to obscure their age and comply with HIPAA.  These ages appear in the data as >= 300.  They do, however, show up in the correct `>= 90` decade bucket in the charts following.


```r
age_all <- pat_icu %>%
    filter(FIRST_ICUSTAY) %>% 
    select(SUBJECT_ID, HADM_ID, GENDER, ADMISSION_DECADE) %>% 
    ggplot(aes(x = ADMISSION_DECADE)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        x = "Age Group", 
        y = NULL)

age_m <- pat_icu %>%
    filter(FIRST_ICUSTAY, GENDER == 'M') %>% 
    select(SUBJECT_ID, HADM_ID, GENDER, ADMISSION_DECADE) %>% 
    ggplot(aes(x = ADMISSION_DECADE)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        title = "Men",
        x = "Age Group", 
        y = NULL) +
    theme(axis.text = element_text(size = 7))

age_f <- pat_icu %>%
    filter(FIRST_ICUSTAY, GENDER == 'F') %>% 
    select(SUBJECT_ID, HADM_ID, GENDER, ADMISSION_DECADE) %>% 
    ggplot(aes(x = ADMISSION_DECADE)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        title = "Women",
        x = "Age Group", 
        y = NULL) +
    theme(axis.text = element_text(size = 7))

age_all / ((age_m + age_f) + plot_layout(ncol = 2)) + 
    plot_annotation(
        title = "Population Age at Admission to Hospital",
        subtitle = "By Decade",
        caption = "Source: MIMIIC-III v1.4"
    )
```

<img src="mimic_population_statistics_files/figure-html/pat_age_plot-1.png" width="100%" style="display: block; margin: auto;" />

### Admission Characteristics



Emergency admissions accounted for the largest number (41,447) and highest percentage (83.25) of admissions.



```r
pat_icu %>% 
    filter(FIRST_ICUSTAY) %>% 
    ggplot(aes(x = ADMISSION_TYPE)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        title = "Reason for Admission to Hospital",
        caption = "Source: MIMIIC-III v1.4",
        y = NULL,
        x = "Type of Admission") +
    scale_x_discrete(limits=rev)
```

<img src="mimic_population_statistics_files/figure-html/adm_char_plot-1.png" width="70%" style="display: block; margin: auto;" />

```r

pat_icu %>% 
    filter(FIRST_ICUSTAY) %>% 
    ggplot(aes(x = ADMISSION_LOCATION)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        title = "Reason for Admission to Hospital",
        caption = "Source: MIMIIC-III v1.4",
        y = NULL,
        x = "Type of Admission") +
    scale_x_discrete(limits=rev)
```

<img src="mimic_population_statistics_files/figure-html/adm_char_plot-2.png" width="70%" style="display: block; margin: auto;" />

```r

pat_icu %>% 
    filter(FIRST_ICUSTAY) %>% 
    ggplot(aes(x = DISCHARGE_LOCATION)) +
    geom_bar(
        fill = "#FF9999",
        color = "white",
        na.rm = TRUE) +
    labs(
        title = "Reason for Admission to Hospital",
        caption = "Source: MIMIIC-III v1.4",
        y = NULL,
        x = "Type of Admission") +
    scale_x_discrete(limits=rev)
```

<img src="mimic_population_statistics_files/figure-html/adm_char_plot-3.png" width="70%" style="display: block; margin: auto;" />




