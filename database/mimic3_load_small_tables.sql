.print 'Loading mimic3 smaller table csv files...'

.mode csv

DROP TABLE IF EXISTS load_temp;

.print 'ADMISSIONS'
.import ../rawdata/ADMISSIONS.csv load_temp
INSERT INTO ADMISSIONS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'CALLOUT'
.import ../rawdata/CALLOUT.csv load_temp
INSERT INTO CALLOUT select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'CAREGIVERS'
.import ../rawdata/CAREGIVERS.csv load_temp
INSERT INTO CAREGIVERS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'CPTEVENTS'
.import ../rawdata/CPTEVENTS.csv load_temp
INSERT INTO CPTEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'DIAGNOSES_ICD'
.import ../rawdata/DIAGNOSES_ICD.csv load_temp
INSERT INTO DIAGNOSES_ICD select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'DRGCODES'
.import ../rawdata/DRGCODES.csv load_temp
INSERT INTO DRGCODES select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'D_CPT'
.import ../rawdata/D_CPT.csv load_temp
INSERT INTO D_CPT select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'D_ICD_DIAGNOSES'
.import ../rawdata/D_ICD_DIAGNOSES.csv load_temp
INSERT INTO D_ICD_DIAGNOSES select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'D_ICD_PROCEDURES'
.import ../rawdata/D_ICD_PROCEDURES.csv load_temp
INSERT INTO D_ICD_PROCEDURES select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'D_ITEMS'
.import ../rawdata/D_ITEMS.csv load_temp
INSERT INTO D_ITEMS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'D_LABITEMS'
.import ../rawdata/D_LABITEMS.csv load_temp
INSERT INTO D_LABITEMS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'ICUSTAYS'
.import ../rawdata/ICUSTAYS.csv load_temp
INSERT INTO ICUSTAYS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'MICROBIOLOGYEVENTS'
.import ../rawdata/MICROBIOLOGYEVENTS.csv load_temp
INSERT INTO MICROBIOLOGYEVENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'PATIENTS'
.import ../rawdata/PATIENTS.csv load_temp
INSERT INTO PATIENTS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'PROCEDUREEVENTS_MV'
.import ../rawdata/PROCEDUREEVENTS_MV.csv load_temp
INSERT INTO PROCEDUREEVENTS_MV select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'PROCEDURES_ICD'
.import ../rawdata/PROCEDURES_ICD.csv load_temp
INSERT INTO PROCEDURES_ICD select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'SERVICES'
.import ../rawdata/SERVICES.csv load_temp
INSERT INTO SERVICES select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.print 'TRANSFERS'
.import ../rawdata/TRANSFERS.csv load_temp
INSERT INTO TRANSFERS select * from load_temp;
DROP TABLE IF EXISTS load_temp;

.exit
