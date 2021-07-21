.print 'Fixing NULLS in data fields for mimic3 tables...'

-- INT and SMALLINT not specified as NOT NULL

UPDATE admissions set HOSPITAL_EXPIRE_FLAG = NULL where HOSPITAL_EXPIRE_FLAG = "";

UPDATE callout set SUBMIT_WARDID = NULL where SUBMIT_WARDID = "";

UPDATE callout set CURR_WARDID = NULL where CURR_WARDID = "";

UPDATE callout set CALLOUT_WARDID = NULL where CALLOUT_WARDID = "";

UPDATE callout set DISCHARGE_WARDID = NULL where DISCHARGE_WARDID = "";

UPDATE chartevents set HADM_ID = NULL where HADM_ID = "";

UPDATE chartevents set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE chartevents set ITEMID = NULL where ITEMID = "";

UPDATE chartevents set CGID = NULL where CGID = "";

UPDATE chartevents set WARNING = NULL where WARNING = "";

UPDATE chartevents set ERROR = NULL where ERROR = "";

UPDATE cptevents set CPT_NUMBER = NULL where CPT_NUMBER = "";

UPDATE cptevents set TICKET_ID_SEQ = NULL where TICKET_ID_SEQ = "";

UPDATE datetimeevents set HADM_ID = NULL where HADM_ID = "";

UPDATE datetimeevents set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE datetimeevents set WARNING = NULL where WARNING = "";

UPDATE datetimeevents set ERROR = NULL where ERROR = "";

UPDATE diagnoses_icd set SEQ_NUM = NULL where SEQ_NUM = "";

UPDATE drgcodes set DRG_SEVERITY = NULL where DRG_SEVERITY = "";

UPDATE drgcodes set DRG_MORTALITY = NULL where DRG_MORTALITY = "";

UPDATE d_items set CONCEPTID = NULL where CONCEPTID = "";

UPDATE inputevents_cv set HADM_ID = NULL where HADM_ID = "";

UPDATE inputevents_cv set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE inputevents_cv set ITEMID = NULL where ITEMID = "";

UPDATE inputevents_cv set CGID = NULL where CGID = "";

UPDATE inputevents_cv set ORDERID = NULL where ORDERID = "";

UPDATE inputevents_cv set LINKORDERID = NULL where LINKORDERID = "";

UPDATE inputevents_cv set NEWBOTTLE = NULL where NEWBOTTLE = "";

UPDATE inputevents_mv set HADM_ID = NULL where HADM_ID = "";

UPDATE inputevents_mv set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE inputevents_mv set ITEMID = NULL where ITEMID = "";

UPDATE inputevents_mv set CGID = NULL where CGID = "";

UPDATE inputevents_mv set ORDERID = NULL where ORDERID = "";

UPDATE inputevents_mv set LINKORDERID = NULL where LINKORDERID = "";

UPDATE inputevents_mv set ISOPENBAG = NULL where ISOPENBAG = "";

UPDATE inputevents_mv set CONTINUEINNEXTDEPT = NULL where CONTINUEINNEXTDEPT = "";

UPDATE inputevents_mv set CANCELREASON = NULL where CANCELREASON = "";

UPDATE labevents set HADM_ID = NULL where HADM_ID = "";

UPDATE microbiologyevents set HADM_ID = NULL where HADM_ID = "";

UPDATE microbiologyevents set SPEC_ITEMID = NULL where SPEC_ITEMID = "";

UPDATE microbiologyevents set ORG_ITEMID = NULL where ORG_ITEMID = "";

UPDATE microbiologyevents set ISOLATE_NUM = NULL where ISOLATE_NUM = "";

UPDATE microbiologyevents set AB_ITEMID = NULL where AB_ITEMID = "";

UPDATE noteevents set HADM_ID = NULL where HADM_ID = "";

UPDATE noteevents set CGID = NULL where CGID = "";

UPDATE outputevents set HADM_ID = NULL where HADM_ID = "";

UPDATE outputevents set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE outputevents set ITEMID = NULL where ITEMID = "";

UPDATE outputevents set CGID = NULL where CGID = "";

UPDATE outputevents set ISERROR = NULL where ISERROR = "";

UPDATE prescriptions set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE procedureevents_mv set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE procedureevents_mv set ITEMID = NULL where ITEMID = "";

UPDATE procedureevents_mv set CGID = NULL where CGID = "";

UPDATE procedureevents_mv set ORDERID = NULL where ORDERID = "";

UPDATE procedureevents_mv set LINKORDERID = NULL where ICUSTAY_ID = "";

UPDATE procedureevents_mv set ISOPENBAG = NULL where ISOPENBAG = "";

UPDATE procedureevents_mv set CONTINUEINNEXTDEPT = NULL where CONTINUEINNEXTDEPT = "";

UPDATE procedureevents_mv set CANCELREASON = NULL where CANCELREASON = "";

UPDATE transfers set ICUSTAY_ID = NULL where ICUSTAY_ID = "";

UPDATE transfers set PREV_WARDID = NULL where PREV_WARDID = "";

UPDATE transfers set CURR_WARDID = NULL where CURR_WARDID = "";


-- DOUBLE PRECISION not specified as NOT NULL

UPDATE chartevents set VALUENUM = NULL where VALUENUM = "";

UPDATE icustays set LOS = NULL where LOS = "";

UPDATE inputevents_cv set AMOUNT = NULL where AMOUNT = "";

UPDATE inputevents_cv set RATE = NULL where RATE = "";

UPDATE inputevents_cv set ORIGINALAMOUNT = NULL where ORIGINALAMOUNT = "";

UPDATE inputevents_cv set ORIGINALRATE = NULL where ORIGINALRATE = "";

UPDATE inputevents_mv set AMOUNT = NULL where AMOUNT = "";

UPDATE inputevents_mv set RATE = NULL where RATE = "";

UPDATE inputevents_mv set PATIENTWEIGHT = NULL where PATIENTWEIGHT = "";

UPDATE inputevents_mv set TOTALAMOUNT = NULL where TOTALAMOUNT = "";

UPDATE inputevents_mv set ORIGINALAMOUNT = NULL where ORIGINALAMOUNT = "";

UPDATE inputevents_mv set ORIGINALRATE = NULL where ORIGINALRATE = "";

UPDATE labevents set VALUENUM = NULL where VALUENUM = "";

UPDATE microbiologyevents set DILUTION_VALUE = NULL where DILUTION_VALUE = "";

UPDATE outputevents set VALUE = NULL where VALUE = "";

UPDATE procedureevents_mv set VALUE = NULL where VALUE = "";

UPDATE transfers set LOS = NULL where LOS = "";

.exit
